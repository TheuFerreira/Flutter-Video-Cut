import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:flutter_video_cut/app/shared/services/directory_service.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoCore {
  String path;
  VideoCore(this.path);

  Future<List<String>?> cutInClips({
    int maxSecondsByClip = 29,
    String prefixFileName = 'file',
  }) async {
    int seconds = await getTotalSecondsOfVideo();

    List<String>? paths = [];
    final clips = (seconds / maxSecondsByClip).ceil();
    final directoryPath = await DirectoryService.getTemporaryDirectoryPath();

    for (int i = 0; i < clips; i++) {
      String? newFilePath = await _generateClip(
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

  Future<int> getTotalSecondsOfVideo() async {
    final duration = await getDuration();
    String value = duration.split('.')[0];
    return int.parse(value);
  }

  Future<String> getDuration() async {
    final videoInformation = await FFprobeKit.getMediaInformation(path);
    return videoInformation.getMediaInformation()!.getDuration()!;
  }

  Future<String?> _generateClip(
    int i,
    int secondsToStart,
    String prefixFileName,
    String directoryPath,
    int maxSecondsByClip,
  ) async {
    String newFile = generateNewFilePath(prefixFileName, i, directoryPath);
    await FileService().deleteIfExists(newFile);

    final command =
        "-ss $secondsToStart -i $path -t $maxSecondsByClip -c copy $newFile";

    final result = await FFmpegKit.execute(command);
    final returnCode = await result.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return newFile;
    } else {
      return null;
    }
  }

  String generateNewFilePath(
      String prefixFileName, int i, String directoryPath) {
    String fileName = prefixFileName + (i + 1).toString();
    return directoryPath + '/$fileName.mp4';
  }

  Future<List<Uint8List>> getThumbnails(List<String> paths) async {
    List<Uint8List> thumbnails = [];
    for (String p in paths) {
      final result = await getThumbnail(p);
      thumbnails.add(result);
    }

    return thumbnails;
  }

  Future<Uint8List> getThumbnail(String path) async {
    final response = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.PNG,
    );

    return response!;
  }
}
