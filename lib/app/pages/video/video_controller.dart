import 'dart:async';
import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/dialogs/info_dialog.dart';
import 'package:flutter_video_cut/app/pages/join/join_page.dart';
import 'package:flutter_video_cut/app/utils/playback_speeds.dart';
import 'package:flutter_video_cut/app/utils/playback_type.dart';
import 'package:flutter_video_cut/domain/entities/playback_speed.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/app/dialogs/dialog_service.dart';
import 'package:flutter_video_cut/domain/use_cases/delete_file_from_storage_case.dart';
import 'package:flutter_video_cut/domain/use_cases/save_file_in_gallery_case.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'video_controller.g.dart';

class VideoController = _VideoControllerBase with _$VideoController;

abstract class _VideoControllerBase with Store {
  final animateIconController = AnimateIconController();

  @observable
  bool isLoaded = false;

  @observable
  ObservableList<Clip> clips = ObservableList<Clip>();

  @observable
  int selectedClip = -1;

  @computed
  bool get isFirstClip => selectedClip == 0;

  @computed
  bool get isLastClip {
    if (clips.isEmpty) {
      return false;
    }

    return selectedClip == clips.length - 1;
  }

  @observable
  PlaybackType playbackType = PlaybackType.repeatOne;

  @observable
  PlaybackSpeed playbackSpeed = playbackSpeeds[0];

  bool _isPlaying = false;

  @observable
  double currentTime = 0;

  @observable
  double totalTime = 1;

  @observable
  VideoPlayerController? playerController;

  bool get _isLoop => playbackType == PlaybackType.loop;

  final _deleteFileFromStorageCase = Modular.get<DeleteFileFromStorageCase>();
  final _saveFileInGalleryCase = Modular.get<SaveFileInGalleryCase>();
  final _dialogService = DialogService();

  Timer? _timerTrack;

  @action
  void start(List<Clip> tempClips) => _start(tempClips);
  _start(List<Clip> tempClips) async {
    isLoaded = false;

    for (final clip in tempClips) {
      clips.add(clip);
    }

    selectedClip = 0;
    await _loadClip(clips[selectedClip]);
  }

  @action
  void selectClip(int index) => _selectClip(index);
  _selectClip(int index) async {
    selectedClip = index;
    await _loadClip(clips[selectedClip]);
  }

  _loadClip(Clip clip) async {
    isLoaded = false;

    currentTime = 0;
    totalTime = 1;
    _timerTrack?.cancel();
    playerController?.dispose();

    final file = File(clip.url);
    playerController = VideoPlayerController.file(file);
    await playerController!.initialize();
    await playerController!.setLooping(playbackType == PlaybackType.repeat);
    await playerController!.setPlaybackSpeed(playbackSpeed.value);
    totalTime = playerController!.value.duration.inMilliseconds.toDouble();

    if (_isLoop) {
      await playerController!.play();
      _updatePlaying(true);
    }

    playerController!.addListener(() {
      _videoEnded();
      _checkIsPlaying();
      _updateCurrentTime();
    });

    _startTimer();

    isLoaded = true;
  }

  _videoEnded() async {
    final playerValue = playerController!.value;
    final isEnded = playerValue.duration == playerValue.position;

    if (!isEnded || playerValue.isPlaying || !_isLoop) {
      return;
    }

    selectedClip++;
    if (selectedClip == clips.length) {
      selectedClip = 0;
    }

    selectClip(selectedClip);
  }

  @action
  void previousClip() => _selectClip(selectedClip - 1);

  @action
  void nextClip() => _selectClip(selectedClip + 1);

  @action
  void resumeVideo() => _resumeVideo();
  _resumeVideo() async {
    if (!playerController!.value.isPlaying) {
      await playerController!.play();
    } else {
      await playerController!.pause();
    }

    _checkIsPlaying();
  }

  _checkIsPlaying() {
    if (playerController!.value.isPlaying) {
      _updatePlaying(true);
      _startTimer();
    } else {
      _updatePlaying(false);
      _timerTrack?.cancel();
    }
  }

  _updatePlaying(bool value) {
    _isPlaying = value;
    if (_isPlaying) {
      animateIconController.animateToEnd();
    } else {
      animateIconController.animateToStart();
    }
  }

  _startTimer() {
    const duration = Duration(milliseconds: 500);

    _timerTrack = Timer.periodic(
      duration,
      (_) => _updateCurrentTime(),
    );
  }

  @action
  void changePlaybackType() => _changePlaybackType();
  _changePlaybackType() async {
    if (playbackType == PlaybackType.repeatOne) {
      playbackType = PlaybackType.repeat;
    } else if (playbackType == PlaybackType.repeat) {
      playbackType = PlaybackType.loop;
    } else if (_isLoop) {
      playbackType = PlaybackType.repeatOne;
    }

    await playerController!.setLooping(playbackType == PlaybackType.repeat);
  }

  @action
  void changePlaybackSpeed() => _changePlaybackSpeed();
  _changePlaybackSpeed() async {
    int index = playbackSpeeds.indexOf(playbackSpeed);
    index++;
    if (index == playbackSpeeds.length) {
      index = 0;
    }

    playbackSpeed = playbackSpeeds[index];
    await playerController!.setPlaybackSpeed(playbackSpeed.value);
  }

  @action
  void startChangeTrack(double newValue) {
    _timerTrack?.cancel();

    changeTrack(newValue);
  }

  @action
  void endChangeTrack(double newValue) {
    changeTrack(newValue);

    _startTimer();
    _updateCurrentTime();
  }

  @action
  void changeTrack(double newValue) =>
      playerController!.seekTo(Duration(milliseconds: newValue.toInt()));

  _updateCurrentTime() {
    final milliseconds = playerController!.value.position.inMilliseconds;
    currentTime = milliseconds.toDouble();
  }

  @action
  void deleteClip(BuildContext context) => _deleteClip(context);
  _deleteClip(BuildContext context) async {
    final delete = await _dialogService.showQuestionDialog(
      context,
      'Confirmação de Exclusão',
      'Tem certeza de que deseja excluir o clip selecionado?',
    );
    if (delete != true) {
      return;
    }

    _updatePlaying(false);

    final index = selectedClip;
    Clip clip = clips[index];
    clips.remove(clip);

    _deleteFileFromStorageCase(clip.url);
    _dialogService.showMessage('Clip ${index + 1} deletado com sucesso');

    if (clips.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final nextIndex = index == 0 ? index : index - 1;
    await _selectClip(nextIndex);
  }

  @action
  void saveFileInGallery(BuildContext context) => _saveFileInGallery(context);
  _saveFileInGallery(BuildContext context) async {
    final clip = clips[selectedClip];

    final infoDialog = InfoDialog();
    infoDialog.show(context, text: 'Estamos salvando seu vídeo na galeria...');

    await Future.delayed(const Duration(seconds: 2));
    await _saveFileInGalleryCase(clip.url);

    infoDialog.close();
  }

  @action
  void joinClips(BuildContext context) {
    Navigator.of(context)
        .push<List<Clip>>(
          MaterialPageRoute(
              builder: (_) => JoinPage(clips: List<Clip>.from(clips))),
        )
        .then(_joinClips);
  }

  _joinClips(List<Clip>? newClips) async {
    if (newClips == null) {
      return;
    }

    isLoaded = false;
    selectedClip = -1;
    clips.clear();

    for (final clip in newClips) {
      clips.add(clip);
    }

    selectedClip = 0;
    await _loadClip(clips[selectedClip]);
  }

  void dispose() {
    _timerTrack?.cancel();
    playerController?.dispose();

    for (Clip clip in clips) {
      _deleteFileFromStorageCase(clip.url);
    }
  }
}
