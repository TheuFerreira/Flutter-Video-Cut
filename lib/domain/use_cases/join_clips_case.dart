import 'dart:io';

import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/services/datetime_service.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';

abstract class JoinClipsCase {
  Future<Clip> call(List<Clip> clips);
}

class JoinClipsCaseImpl implements JoinClipsCase {
  final VideoService _videoService;
  final PathService _pathService;
  final DateTimeService _dateTimeService;
  final LogService _logService;

  JoinClipsCaseImpl(
    this._videoService,
    this._pathService,
    this._dateTimeService,
    this._logService,
  );

  @override
  Future<Clip> call(List<Clip> clips) async {
    _logService.writeInfo('Getting a cache path');
    final cachePath = await _pathService.getCachePath();

    _logService.writeInfo('Generating a file with a clips to join in a txt...');
    final txtPath = '$cachePath/videos.txt';
    final txtFile = File(txtPath);
    if (await txtFile.exists()) {
      await txtFile.delete();
    }

    _logService.writeInfo('Adding url files to txt');
    for (final clip in clips) {
      final contents = "file '${clip.url}'\r\n";
      await txtFile.writeAsString(contents, mode: FileMode.append);
    }

    _logService.writeInfo('Generating a Base File Name');
    String baseFileName = 'VideoCut-';
    baseFileName += _dateTimeService.getFormattedDateToFileName(DateTime.now());

    _logService.writeInfo('Joining clips...');
    final path = await _videoService.joinClips(
      pathTxtFile: txtPath,
      destiny: cachePath,
      baseFileName: baseFileName,
    );

    if (path == null) {
      _logService.writeError('Error on joining clips');
      throw Exception();
    }

    _logService.writeInfo('Getting thumbnail of video...');
    final thumbnail = await _videoService.getThumbnail(path);

    final finalClip =
        Clip(index: clips[0].index, url: path, thumbnail: thumbnail!);
    return finalClip;
  }
}
