import 'dart:async';
import 'dart:io';

import 'package:flutter_video_cut/app/screens/info_cuts/enums/player_state.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/models/playback_speed.dart';
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

  @observable
  int selectedSpeed = 0;

  List<PlaybackSpeed> speeds = ObservableList.of(const [
    PlaybackSpeed('1x', 1),
    PlaybackSpeed('1.5x', 1.5),
    PlaybackSpeed('2x', 2),
  ]);

  late VideoPlayerController? controller;
  Timer? timer;

  @action
  Future<void> loadClip(String clipPath) async {
    state = PlayerState.loading;

    _cancelTimer();

    final file = File(clipPath);

    controller = VideoPlayerController.file(file);
    await controller!.setLooping(true);
    await controller!.initialize();
    await _setPlaybackSpeed();

    maxSeconds = controller!.value.duration.inSeconds.toDouble();
    currentTime = 0;

    state = PlayerState.initialized;
    isPlaying = false;
    showControllers = false;
  }

  @action
  Future nextPlaybackSpeed() async {
    selectedSpeed++;
    if (selectedSpeed == speeds.length) {
      selectedSpeed = 0;
    }

    await _setPlaybackSpeed();
  }

  Future _setPlaybackSpeed() async {
    await controller!.setPlaybackSpeed(speeds[selectedSpeed].value);
  }

  @action
  Future playPause() async {
    final playing = controller!.value.isPlaying;
    if (playing) {
      await controller!.pause();
      _cancelTimer();
    } else {
      await controller!.play();
      _startTimer();
    }

    isPlaying = !playing;
  }

  @action
  Future moveClip(double value) async {
    await controller!.seekTo(Duration(seconds: value.toInt()));
    await _updateCurrentTime();
  }

  void _startTimer() {
    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) async => await _updateCurrentTime(),
    );
  }

  Future _updateCurrentTime() async {
    final duration = await controller!.position;
    currentTime = duration!.inSeconds.toDouble();
  }

  @action
  void updateControllers() {
    showControllers = !showControllers;
    if (showControllers == false) {
      return;
    }
  }

  Future dispose() async {
    _cancelTimer();
    await controller!.dispose();
  }

  void _cancelTimer() {
    if (timer == null) return;

    timer!.cancel();
  }
}
