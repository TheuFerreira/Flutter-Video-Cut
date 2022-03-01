import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_min/media_information.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:flutter_video_cut/app/shared/erros/video_limit_exception.dart';
import 'package:flutter_video_cut/app/shared/services/directory_service.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';

abstract class IVideoService {
  Future<List<String>?> cutInClips(String path, {int maxSecondsByClip = 29, String prefixFileName = 'file'});
  Future<int> getTotalSecondsOfVideo(String path);
}

class VideoService implements IVideoService {
  final IDirectoryService _directoryService;
  final IFileService _fileService;
  final int _maxTimeOfVideoInSeconds = 600;

  VideoService(this._directoryService, this._fileService);

  @override
  Future<List<String>?> cutInClips(String path, {int maxSecondsByClip = 29, String prefixFileName = 'file'}) async {
    int seconds = await getTotalSecondsOfVideo(path);
    if (seconds > _maxTimeOfVideoInSeconds) {
      throw VideoLimitException(seconds.toString());
    }

    List<String>? paths = [];
    final clips = (seconds / maxSecondsByClip).ceil();
    final directoryPath = await _directoryService.getTemporaryPath();

    for (int i = 0; i < clips; i++) {
      String? newFilePath = await _generateClip(
        path,
        i,
        (i * maxSecondsByClip),
        prefixFileName,
        directoryPath,
        maxSecondsByClip,
      );

      if (newFilePath != null) {
        paths.add(newFilePath);
      } else {
        return null;
      }
    }

    return paths;
  }

  @override
  Future<int> getTotalSecondsOfVideo(String path) async {
    final duration = await _getDuration(path);
    String value = duration.split('.')[0];
    return int.parse(value);
  }

  Future<String> _getDuration(String path) async {
    final videoInformation = await FFprobeKit.getMediaInformation(path);
    MediaInformation? mediaInformation = videoInformation.getMediaInformation();
    return mediaInformation!.getDuration()!;
  }

  Future<String?> _generateClip(
    String path,
    int i,
    int secondsToStart,
    String prefixFileName,
    String directoryPath,
    int maxSecondsByClip,
  ) async {
    String newFile = _generateNewFilePath(prefixFileName, i, directoryPath);
    await _fileService.deleteIfExists(newFile);

    final command = "-ss $secondsToStart -i $path -t $maxSecondsByClip -c copy -avoid_negative_ts 1 $newFile";

    final result = await FFmpegKit.execute(command);
    final returnCode = await result.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return newFile;
    } else {
      return null;
    }
  }

  String _generateNewFilePath(String prefixFileName, int i, String directoryPath) {
    String fileName = prefixFileName + (i + 1).toString();
    return directoryPath + '/$fileName.mp4';
  }
}
