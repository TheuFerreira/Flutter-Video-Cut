import 'dart:async';
import 'dart:developer';
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

  @observable
  double maxSeconds = 1;

  @observable
  double currentTime = 0;

  late VideoPlayerController? controller;
  Timer? timer;

  @action
  Future<void> loadClip(String clipPath) async {
    state = PlayerState.loading;
    if (timer != null) timer!.cancel();
    final file = File(clipPath);

    controller = VideoPlayerController.file(file);
    await controller!.setLooping(true);
    await controller!.initialize();

    maxSeconds = controller!.value.duration.inSeconds.toDouble();
    currentTime = 0;

    state = PlayerState.initialized;
    isPlaying = false;
    showControllers = false;
  }

  @action
  Future playPause() async {
    final playing = controller!.value.isPlaying;
    if (playing) {
      await controller!.pause();
      if (timer != null) timer!.cancel();
    } else {
      await controller!.play();
      startTimer();
    }

    isPlaying = !playing;
  }

  @action
  Future moveClip(double value) async {
    await controller!.seekTo(Duration(seconds: value.toInt()));
    currentTime = (await controller!.position)!.inSeconds.toDouble();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) async {
        currentTime = (await controller!.position)!.inSeconds.toDouble();
        log(currentTime.toString());
      },
    );
  }

  @action
  void updateControllers() {
    showControllers = !showControllers;
    if (showControllers == false) {
      return;
    }
  }

  Future dispose() async {
    if (timer != null) timer!.cancel();
    await controller!.dispose();
  }
}

// TODO: Clean Code