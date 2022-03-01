import 'dart:async';
import 'dart:io';

import 'package:flutter_video_cut/app/screens/info_cuts/enums/player_state.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'player_controller.g.dart';

class PlayerController = _PlayerControllerBase with _$PlayerController;

abstract class _PlayerControllerBase with Store {
  late Function() onEnded;

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

  @observable
  bool showPrevious = false;

  @observable
  bool showNext = true;

  bool _isLooping = true;

  double _selectedSpeed = 1;
  late VideoPlayerController? controller;
  Timer? timerCurrentTime;

  @action
  Future<void> loadClip(String clipPath) async {
    state = PlayerState.loading;

    _cancelTimerCurrentTime();

    final file = File(clipPath);

    controller = VideoPlayerController.file(file);
    await controller!.setLooping(_isLooping);
    await controller!.initialize();
    controller!.addListener(checkVideoIsEnded);
    await _setPlaybackSpeed();

    maxSeconds = controller!.value.duration.inSeconds.toDouble();
    currentTime = 0;

    state = PlayerState.initialized;
    isPlaying = false;
    showControllers = false;
  }

  Future setIsLooping(bool value) async {
    _isLooping = value;

    if (controller != null) {
      await controller!.setLooping(_isLooping);
    }
  }

  Future setPlaybackSpeed(double value) async {
    _selectedSpeed = value;
    await _setPlaybackSpeed();
  }

  Future _setPlaybackSpeed() async {
    await controller!.setPlaybackSpeed(_selectedSpeed);
  }

  @action
  Future playPause() async {
    final playing = controller!.value.isPlaying;
    if (playing) {
      await controller!.pause();
      _cancelTimerCurrentTime();
    } else {
      await controller!.play();
      _startTimerCurrentTime();
    }

    isPlaying = !playing;
  }

  @action
  Future moveClip(double value) async {
    await controller!.seekTo(Duration(seconds: value.toInt()));
    await _updateCurrentTime();
  }

  void _startTimerCurrentTime() {
    timerCurrentTime = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) async => await _updateCurrentTime(),
    );
  }

  Future _updateCurrentTime() async {
    final duration = await controller!.position;
    if (duration != null) {
      currentTime = duration!.inSeconds.toDouble();
    }
  }

  @action
  void updateControllers() {
    showControllers = !showControllers;
  }

  Future dispose() async {
    _cancelTimerCurrentTime();

    controller!.removeListener(checkVideoIsEnded);
    await controller!.dispose();
  }

  void checkVideoIsEnded() {
    if (controller!.value.duration != controller!.value.position) {
      return;
    }

    if (isPlaying == true) {
      isPlaying = false;
      onEnded();
    }
  }

  void _cancelTimerCurrentTime() {
    if (timerCurrentTime != null) {
      timerCurrentTime!.cancel();
    }
  }
}
