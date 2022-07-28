import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/dialogs/info_dialog.dart';
import 'package:flutter_video_cut/app/utils/playback_speeds.dart';
import 'package:flutter_video_cut/app/utils/playback_type.dart';
import 'package:flutter_video_cut/domain/entities/playback_speed.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/app/pages/video/components/clip_component.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/app/dialogs/dialog_service.dart';
import 'package:flutter_video_cut/domain/use_cases/delete_file_from_storage_case.dart';
import 'package:flutter_video_cut/domain/use_cases/save_file_in_gallery_case.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'video_controller.g.dart';

class VideoController = _VideoControllerBase with _$VideoController;

abstract class _VideoControllerBase with Store {
  final listKey = GlobalKey<AnimatedListState>();

  @observable
  List<Clip> clips = ObservableList<Clip>();

  @observable
  PlaybackType playbackType = PlaybackType.repeatOne;

  @observable
  PlaybackSpeed playbackSpeed = playbackSpeeds[0];

  @observable
  int selectedClip = 0;

  @computed
  bool get isFirstClip => selectedClip == 0;

  @computed
  bool get isLastClip => selectedClip == clips.length - 1;

  @observable
  bool isPlaying = false;

  @observable
  double currentTime = 0;

  @computed
  double get totalTime =>
      playerController!.value.duration.inMilliseconds.toDouble();

  @observable
  VideoPlayerController? playerController;

  @observable
  bool isLoaded = false;

  final _storageService = Modular.get<StorageService>();
  final _deleteFileFromStorageCase = Modular.get<DeleteFileFromStorageCase>();
  final _saveFileInGalleryCase = Modular.get<SaveFileInGalleryCase>();
  final _dialogService = DialogService();

  Timer? _timerTrack;

  @action
  Future<void> load(List<Clip> tempClips) async {
    for (final clip in tempClips) {
      clips.add(clip);
    }

    loadFile(clips[0].url);
  }

  @action
  Future<void> deleteClip(BuildContext context) async {
    final delete = await _dialogService.showQuestionDialog(
      context,
      'Confirmação de Exclusão',
      'Tem certeza de que deseja excluir o clip selecionado?',
    );
    if (delete != true) {
      return;
    }

    isPlaying = false;

    int index = selectedClip;

    listKey.currentState!.removeItem(
      index,
      (context, animation) {
        return SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          axis: Axis.horizontal,
          child: ClipComponent(
            index: index,
            thumbnail: clips[index].thumbnail,
            isSelected: true,
            title: '',
            onTap: (index) {},
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 300));

    _dialogService.showMessage('Clip ${index + 1} deletado com sucesso');

    Clip clip = clips[index];
    clips.remove(clip);

    await Future.delayed(const Duration(milliseconds: 100));

    _deleteFileFromStorageCase(clip.url);

    if (clips.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final nextIndex = index == 0 ? index : index - 1;
    await selectClip(nextIndex);
  }

  @action
  void previousClip() => selectClip(selectedClip - 1);

  @action
  void nextClip() => selectClip(selectedClip + 1);

  @action
  Future<void> selectClip(int index) async {
    isPlaying = false;

    selectedClip = index;
    final clip = clips[index];
    await loadFile(clip.url);
  }

  @action
  Future<void> loadFile(String url) async {
    isLoaded = false;

    currentTime = 0;
    _timerTrack?.cancel();
    playerController?.dispose();

    final file = File(url);
    playerController = VideoPlayerController.file(file);
    await playerController!.initialize();
    await playerController!.setLooping(playbackType == PlaybackType.repeat);
    await playerController!.setPlaybackSpeed(playbackSpeed.value);

    playerController!.addListener(() {
      videoEnded();
      _checkIsPlaying();
      _timer();
    });

    _startTimer();

    isLoaded = true;
  }

  @action
  Future<void> resumeVideo() async {
    if (!playerController!.value.isPlaying) {
      await playerController!.play();
    } else {
      await playerController!.pause();
    }

    _checkIsPlaying();
  }

  void _checkIsPlaying() {
    if (playerController!.value.isPlaying) {
      isPlaying = true;
      _startTimer();
    } else {
      isPlaying = false;
      _timerTrack?.cancel();
    }
  }

  void _startTimer() => _timerTrack = Timer.periodic(
        const Duration(milliseconds: 500),
        (_) => _timer(),
      );

  void _timer() =>
      currentTime = playerController!.value.position.inMilliseconds.toDouble();

  @action
  void videoEnded() => _videoEnded();

  _videoEnded() async {
    final playerValue = playerController!.value;
    final isEnded = playerValue.duration == playerValue.position;
    final isLoop = playbackType == PlaybackType.loop;

    if (!isEnded || playerValue.isPlaying || !isLoop) {
      return;
    }

    selectedClip++;
    if (selectedClip == clips.length) {
      selectedClip = 0;
    }

    await selectClip(selectedClip);
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
    _timer();
  }

  @action
  void changePlaybackType() => _changePlaybackType();

  _changePlaybackType() async {
    if (playbackType == PlaybackType.repeatOne) {
      playbackType = PlaybackType.repeat;
    } else if (playbackType == PlaybackType.repeat) {
      playbackType = PlaybackType.loop;
    } else if (playbackType == PlaybackType.loop) {
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
  void changeTrack(double newValue) =>
      playerController!.seekTo(Duration(milliseconds: newValue.toInt()));

  void dispose() {
    _timerTrack?.cancel();
    playerController?.dispose();

    for (Clip clip in clips) {
      _storageService.deleteFile(clip.url);
    }
  }
}
