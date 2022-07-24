import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';

abstract class CutVideoCase {
  Future<List<String>> call({
    required String cachedFile,
    required int secondsOfVideo,
    required int secondsOfClip,
  });
}

class CutVideoCaseImpl implements CutVideoCase {
  final VideoService _videoService;
  final PathService _pathService;
  final LogService _logService;

  CutVideoCaseImpl(
    this._videoService,
    this._pathService,
    this._logService,
  );

  @override
  Future<List<String>> call({
    required String cachedFile,
    required int secondsOfVideo,
    required int secondsOfClip,
  }) async {
    _logService.writeInfo('Getting a Cache Path');
    final cachePath = await _pathService.getCachePath();

    _logService.writeInfo('Cut a video in clips');
    final videosCuted = await _videoService.cutVideo(
      url: cachedFile,
      destiny: cachePath,
      secondsOfClip: secondsOfVideo,
      seconds: secondsOfClip,
    );

    if (videosCuted == null) {
      _logService.writeError('Error on cut a video');
      throw VideoCutException();
    }

    _logService.writeInfo('Clips, $videosCuted');
    return videosCuted;
  }
}
