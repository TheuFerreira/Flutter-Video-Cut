import 'dart:async';
import 'dart:io';

import 'package:flutter_video_cut/app/screens/info_cuts/enums/player_state.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'player_controller.g.dart';

class PlayerController = _PlayerControllerBase with _$PlayerController;

abstract class _PlayerControllerBase with Store {
  @observable
  PlayerState state = PlayerState.loading;

  @observable
  bool isPlaying = false;

  @observable
  bool showControllers = false;

  late VideoPlayerController? controller;
  late Timer timer;

  @action
  Future<void> loadClip(String clipPath) async {
    state = PlayerState.loading;
    final file = File(clipPath);

    controller = VideoPlayerController.file(file);
    await controller!.setLooping(true);
    await controller!.initialize();

    state = PlayerState.initialized;
    isPlaying = false;
    showControllers = false;
  }

  @action
  Future playPause() async {
    final playing = controller!.value.isPlaying;
    if (playing) {
      await controller!.pause();
    } else {
      await controller!.play();
    }

    isPlaying = !playing;
  }

  @action
  void updateControllers() {
    showControllers = !showControllers;
    if (showControllers == false) {
      return;
    } else {
      timer.cancel();
    }

    timer = Timer(const Duration(seconds: 2), () {
      showControllers = false;
    });
  }

  Future dispose() async {
    await controller!.dispose();
  }
}
