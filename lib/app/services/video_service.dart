import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';

class VideoService implements IVideoService {
  @override
  Future<List<String>?> cutVideo({
    required String url,
    required String destiny,
    int seconds = 20,
  }) async {
    int maxDuration = await _getDuration(url: url);
    final clips = (maxDuration / seconds).ceil();

    List<String> cutedVideos = [];
    for (int i = 0; i < clips; i++) {
      int timeStart = i * seconds;
      String newPath = "$destiny/${i + 1}.mp4";

      final isCuted = await _cutVideo(
        currentPath: url,
        newPath: newPath,
        seconds: seconds,
        timeStart: timeStart,
      );

      if (!isCuted) {
        return null;
      }

      cutedVideos.add(newPath);
    }

    return cutedVideos;
  }

  Future<int> _getDuration({required String url}) async {
    final videoInformation = await FFprobeKit.getMediaInformation(url);
    final mediaInformation = videoInformation.getMediaInformation();
    String durations = mediaInformation!.getDuration()!;

    String duration = durations.split('.')[0];
    int seconds = int.parse(duration);
    return seconds;
  }

  Future<bool> _cutVideo(
      {required int timeStart,
      required String newPath,
      required String currentPath,
      required int seconds}) async {
    String command =
        "-ss $timeStart -y -i $currentPath -t $seconds -c copy -avoid_negative_ts 1 $newPath";

    final result = await FFmpegKit.execute(command);
    final returnCode = await result.getReturnCode();

    if (!ReturnCode.isSuccess(returnCode)) {
      return false;
    }

    return true;
  }
}
