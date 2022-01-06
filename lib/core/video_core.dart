import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoCore {
  Future<List<String>?> cutInSubclips(
    String path, {
    int maxSecondsByClip = 29,
    String prefixFileName = 'file',
  }) async {
    final duration = await getDuration(path);
    String value = duration.split('.')[0];
    int seconds = int.parse(value);

    List<String> paths = [];
    final clips = (seconds / maxSecondsByClip).ceil();
    final directoryPath = (await getTemporaryDirectory()).path;

    for (int i = 0; i < clips; i++) {
      String fileName = prefixFileName + (i + 1).toString();
      final newFile = directoryPath + '/$fileName.mp4';
      await FileService().deleteIfExists(newFile);

      final secondsToStart = (i * maxSecondsByClip);
      final command =
          "-ss $secondsToStart -i $path -t $maxSecondsByClip -c copy $newFile";

      final result = await FFmpegKit.execute(command);
      final returnCode = await result.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        paths.add(newFile);
      } else {
        return paths;
      }
    }

    return paths;
  }

// TODO: Função de getThumbnail
  Future<List<Uint8List>> getThumbnails(List<String> paths) async {
    List<Uint8List> thumbnails = [];
    for (String path in paths) {
      final result = await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.PNG,
      );

      thumbnails.add(result!);
    }

    return thumbnails;
  }

  Future<String> getDuration(String path) async {
    final videoInformation = await FFprobeKit.getMediaInformation(path);
    return videoInformation.getMediaInformation()!.getDuration()!;
  }
}
