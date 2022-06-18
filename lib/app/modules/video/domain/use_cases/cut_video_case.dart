import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';
import 'package:flutter_video_cut/app/modules/video/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/app/modules/video/domain/services/path_service.dart';
import 'package:flutter_video_cut/app/modules/video/infra/services/path_service_impl.dart';
import 'package:flutter_video_cut/app/services/video_service.dart';

abstract class CutVideoCase {
  Future<List<String>> call({
    required String cachedFile,
    required int secondsOfVideo,
  });
}

class CutVideoCaseImpl implements CutVideoCase {
  final IVideoService _videoService = VideoService();
  final PathService _pathService = PathServiceImpl();

  @override
  Future<List<String>> call({
    required String cachedFile,
    required int secondsOfVideo,
  }) async {
    final cachePath = await _pathService.getCachePath();

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
