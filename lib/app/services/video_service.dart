import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoService implements IVideoService {
  @override
  Future<List<String>?> cutVideo({
    required String url,
    required String destiny,
    required int secondsOfClip,
    int seconds = 20,
  }) async {
    List<String>? cutedVideos = [];
    try {
      int maxDuration = secondsOfClip;
      final clips = (maxDuration / seconds).ceil();

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
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on cut video in clips');

      cutedVideos = null;
    }

    return cutedVideos;
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

  @override
  Future<Uint8List?> getThumbnail(String url) async {
    Uint8List? thumbnail;
    try {
      thumbnail = await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.PNG,
      );
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on get thubmnail of video');

      thumbnail = null;
    }

    return thumbnail!;
  }

  @override
  Future<int> getSeconds(String url) async {
    final videoInformation = await FFprobeKit.getMediaInformation(url);
    final mediaInformation = videoInformation.getMediaInformation();
    String durations = mediaInformation!.getDuration()!;

    String duration = durations.split('.')[0];
    int seconds = int.parse(duration);
    return seconds;
  }
}
