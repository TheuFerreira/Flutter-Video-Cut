import 'package:ffmpeg_kit_flutter_min/ffprobe_kit.dart';
import 'package:flutter_video_cut/app/modules/home/domain/services/video_service.dart';

class VideoServiceImpl implements VideoService {
  @override
  Future<int> getSeconds(String path) async {
    final videoInformation = await FFprobeKit.getMediaInformation(path);
    final mediaInformation = videoInformation.getMediaInformation();
    String durations = mediaInformation!.getDuration()!;

    String duration = durations.split('.')[0];
    int seconds = int.parse(duration);
    return seconds;
  }
}
