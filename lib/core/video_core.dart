import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:flutter_video_cut/core/ffmpeg_status.dart';
import 'package:path_provider/path_provider.dart';

class VideoCore {
  Future<List<String>?> cutInSubclips(
    String path, {
    int maxSecondsByClip = 29,
    String prefixFileName = 'file',
  }) async {
    final duration = await getDuration(path);
    final values = duration.split('.');
    final seconds = int.parse(values[0]);

    List<String> paths = [];
    final clips = (seconds / 29).ceil();
    final directoryPath = (await getTemporaryDirectory()).path;

    for (int i = 0; i < clips; i++) {
      String fileName = prefixFileName + i.toString();
      final newFile = directoryPath + '/$fileName.mp4';
      await FileService().deleteIfExists(newFile);

      final secondsToStart = i * maxSecondsByClip;
      String command =
          "-i $path -ss $secondsToStart -t $maxSecondsByClip -c copy $newFile";

      final result = await FlutterFFmpeg().execute(command);

      if (result == FFmpegStatus.success) {
        paths.add(newFile);
      } else {
        return paths;
      }
    }

    return paths;
  }

  Future<String> getDuration(String path) async {
    final videoInformation = await FlutterFFprobe().getMediaInformation(path);
    return videoInformation.getMediaProperties()!['duration'];
  }
}
