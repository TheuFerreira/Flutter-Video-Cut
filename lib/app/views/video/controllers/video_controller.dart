import 'dart:developer';
import 'dart:io';

import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';
import 'package:flutter_video_cut/app/services/video_service.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

part 'video_controller.g.dart';

class VideoController = _VideoControllerBase with _$VideoController;

abstract class _VideoControllerBase with Store {
  @observable
  VideoPlayerController? playerController;

  @observable
  bool isLoaded = false;

  final IVideoService _videoService = VideoService();

  @action
  Future<void> cutVideo(String url) async {
    final temporaryDirectory = await getTemporaryDirectory();
    final temporaryPath = temporaryDirectory.path;

    final videosCuted =
        await _videoService.cutVideo(url: url, destiny: temporaryPath);
    if (videosCuted == null) {
      return;
    }

    loadFile(videosCuted[0]);
  }

  @action
  Future<void> loadFile(String url) async {
    isLoaded = false;

    final file = File(url);
    playerController = VideoPlayerController.file(file);
    await playerController!.initialize();

    isLoaded = true;
  }

  @action
  Future<void> resumeVideo() async {
    if (!playerController!.value.isPlaying) {
      await playerController!.play();
    } else {
      await playerController!.pause();
    }
  }
}
