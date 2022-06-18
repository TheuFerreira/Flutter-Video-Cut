import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';
import 'package:flutter_video_cut/app/modules/video/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/app/services/video_service.dart';

abstract class CutVideoCase {
  Future<List<String>> call({
    required String cachedFile,
    required String cachePath,
    required int secondsOfVideo,
  });
}

class CutVideoCaseImpl implements CutVideoCase {
  final IVideoService _videoService = VideoService();

  @override
  Future<List<String>> call({
    required String cachedFile,
    required String cachePath,
    required int secondsOfVideo,
  }) async {
    final videosCuted = await _videoService.cutVideo(
      url: cachedFile,
      destiny: cachePath,
      secondsOfClip: secondsOfVideo,
    );

    if (videosCuted == null) {
      throw VideoCutException();
    }

    return videosCuted;
  }
}
