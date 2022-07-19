import 'package:flutter_video_cut/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';
import 'package:flutter_video_cut/domain/utils/time.dart';

abstract class GetSecondsCase {
  Future<int> call(String path);
}

class GetSecondsCaseImpl implements GetSecondsCase {
  final VideoService _videoService;

  GetSecondsCaseImpl(this._videoService);

  final double _minutesInSeconds = 60;

  @override
  Future<int> call(String path) async {
    final secondsOfVideo = await _videoService.getSeconds(path);
    if (secondsOfVideo <= minSecondsPerVideo) {
      throw HomeInvalidVideoException(
          'O limite mínimo é de $minSecondsPerVideo segundos por vídeo.');
    }

    final minutes = secondsOfVideo / _minutesInSeconds;
    if (minutes > maxMinutesPerVideo) {
      throw HomeInvalidVideoException(
          'O limite máximo é de $maxMinutesPerVideo minutos por vídeo.');
    }

    return secondsOfVideo;
  }
}
