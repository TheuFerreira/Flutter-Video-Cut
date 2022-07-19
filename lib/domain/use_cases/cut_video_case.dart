import 'package:flutter_video_cut/domain/errors/video_errors.dart';
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

  CutVideoCaseImpl(this._videoService, this._pathService);

  @override
  Future<List<String>> call({
    required String cachedFile,
    required int secondsOfVideo,
    required int secondsOfClip,
  }) async {
    final cachePath = await _pathService.getCachePath();

    final videosCuted = await _videoService.cutVideo(
      url: cachedFile,
      destiny: cachePath,
      secondsOfClip: secondsOfVideo,
      seconds: secondsOfClip,
    );

    if (videosCuted == null) {
      throw VideoCutException();
    }

    return videosCuted;
  }
}
