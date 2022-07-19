import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/interfaces/idialog_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/app/pages/video/components/clip_component.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/app/services/dialog_service.dart';
import 'package:flutter_video_cut/domain/use_cases/copy_file_to_cache_case.dart';
import 'package:flutter_video_cut/domain/use_cases/cut_video_case.dart';
import 'package:flutter_video_cut/domain/use_cases/delete_file_from_storage_case.dart';
import 'package:flutter_video_cut/domain/use_cases/get_thumbnails_case.dart';
import 'package:flutter_video_cut/domain/use_cases/share_clips_case.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'video_controller.g.dart';

class VideoController = _VideoControllerBase with _$VideoController;

abstract class _VideoControllerBase with Store {
  final listKey = GlobalKey<AnimatedListState>();

  @observable
  List<Clip> clips = ObservableList<Clip>();

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
  final IDialogService _dialogService = DialogService();
  final _cutVideoCase = Modular.get<CutVideoCase>();
  final _copyFileToCacheCase = Modular.get<CopyFileToCacheCase>();
  final _getThumbnailCase = Modular.get<GetThumbnailsCase>();
  final _shareClipsCase = Modular.get<ShareClipsCase>();

  String _cachedFile = '';

  Timer? _timerTrack;

  @action
  Future<void> cutVideo(
      String url, int secondsOfClip, BuildContext context) async {
    List<String> videosCuted = [];

    try {
      _cachedFile = await _copyFileToCacheCase(url);

      videosCuted = await _cutVideoCase(
        cachedFile: _cachedFile,
        secondsOfVideo: secondsOfClip,
      );

      final tempClips = await _getThumbnailCase(videosCuted);
      for (final clip in tempClips) {
        clips.add(clip);
        listKey.currentState!.insertItem(clips.length - 1);
      }

      loadFile(clips[0].url);
    } on ThumbnailException {
      _dialogService.showMessageError(
          'Houve um problema ao buscar as Thumbnails dos vídeos.');
      Navigator.of(context).pop();
    } on VideoCacheException catch (e, s) {
      _dialogService
          .showMessageError('Não foi possível encontrar o Cache do Video Cut.');
      Navigator.of(context).pop();

      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on Get Cache Path');
    } on VideoCopyException {
      _dialogService.showMessageError(
          'Problema ao copiar o arquivo para o cache do Video Cut.');
      Navigator.of(context).pop();
    } on VideoCutException {
      _dialogService
          .showMessageError('Houve um problema ao cortar o vídeo selecionado.');
      Navigator.of(context).pop();
    } on Exception catch (e, s) {
      _dialogService.showMessageError('Um problema aconteceu');
      Navigator.of(context).pop();

      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on Cut Video');
    }
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
  void previousClip() {
    selectClip(selectedClip - 1);
  }

  @action
  void nextClip() {
    selectClip(selectedClip + 1);
  }

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

    playerController!.addListener(() {
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

  void _startTimer() {
    _timerTrack = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _timer(),
    );
  }

  void _timer() {
    currentTime = playerController!.value.position.inMilliseconds.toDouble();
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
  void changeTrack(double newValue) {
    playerController!.seekTo(Duration(milliseconds: newValue.toInt()));
  }

  Future<void> shareFiles() async {
    try {
      await _shareClipsCase(clips);
    } catch (e) {
      _dialogService
          .showMessageError('Ocorreu um problema ao compartilhar os vídeos.');
    }
  }

  void dispose() {
    _timerTrack?.cancel();
    playerController?.dispose();

    for (Clip clip in clips) {
      _storageService.deleteFile(clip.url);
    }

    if (_cachedFile != '') {
      _storageService.deleteFile(_cachedFile);
    }
  }
}
