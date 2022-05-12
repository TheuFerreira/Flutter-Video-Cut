import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'video_controller.g.dart';

class VideoController = _VideoControllerBase with _$VideoController;

abstract class _VideoControllerBase with Store {
  @observable
  VideoPlayerController? playerController;

  @observable
  bool isLoaded = false;

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
