import 'package:flutter_video_cut/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';

abstract class GetSecondsCase {
  Future<int> call(String path);
}

class GetSecondsCaseImpl implements GetSecondsCase {
  final VideoService _videoService;

  GetSecondsCaseImpl(this._videoService);

  final int _minSeconds = 10;
  final int _maxMinutes = 5;

  @override
  Future<int> call(String path) async {
    final secondsOfVideo = await _videoService.getSeconds(path);
    if (secondsOfVideo <= _minSeconds) {
      throw HomeInvalidVideoException(
          'O limite mínimo é de 10 segundos por vídeo.');
    }

    final minutes = secondsOfVideo / 60.0;
    if (minutes > _maxMinutes) {
      throw HomeInvalidVideoException(
          'O limite máximo é de 5 minutos por vídeo.');
    }

    return secondsOfVideo;
  }
}
