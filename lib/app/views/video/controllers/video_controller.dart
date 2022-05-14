import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_video_cut/app/interfaces/idialog_service.dart';
import 'package:flutter_video_cut/app/interfaces/istorage_service.dart';
import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';
import 'package:flutter_video_cut/app/models/clip.dart';
import 'package:flutter_video_cut/app/services/dialog_service.dart';
import 'package:flutter_video_cut/app/services/storage_service.dart';
import 'package:flutter_video_cut/app/services/video_service.dart';
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

  @observable
  VideoPlayerController? playerController;

  @observable
  bool isLoaded = false;

  final IVideoService _videoService = VideoService();
  final IStorageService _storageService = StorageService();
  final IDialogService _dialogService = DialogService();
  String _cachedFile = '';

  @action
  Future<void> cutVideo(String url) async {
    final cachePath = await _storageService.getCachePath();
    if (cachePath == null) {
      _dialogService
          .showMessageError('Não foi possível encontrar o Cache do Video Cut.');
      // TODO: Return to main
      return;
    }

    final values = url.split('.');
    final extension = values[values.length - 1];
    _cachedFile = '$cachePath/cachedFile.$extension';

    bool isCopied = await _storageService.copyFile(url, _cachedFile);
    if (!isCopied) {
      _dialogService.showMessageError(
          'Problema ao copiar o arquivo para o cache do Video Cut.');
      // TODO: Return to main
      return;
    }

    final videosCuted =
        await _videoService.cutVideo(url: _cachedFile, destiny: cachePath);
    if (videosCuted == null) {
      _dialogService
          .showMessageError('Houve um problema ao cortar o vídeo selecionado.');
      // TODO: Return to main
      return;
    }

    for (String videoCuted in videosCuted) {
      Uint8List? thumbnail = await _videoService.getThumbnail(videoCuted);
      if (thumbnail == null) {
        _dialogService.showMessageError(
            'Houve um problema ao buscar as Thumbnails dos vídeos.');
        // TODO: Return to main
        return;
      }

      final clip = Clip(url: videoCuted, thumbnail: thumbnail);

      clips.add(clip);
      listKey.currentState!.insertItem(clips.length - 1);
    }

    loadFile(clips[0].url);
  }

  @action
  Future<void> selectClip(int index) async {
    selectedClip = index;
    final clip = clips[index];
    await loadFile(clip.url);
  }

  @action
  Future<void> loadFile(String url) async {
    isLoaded = false;

    if (playerController != null) {
      playerController!.dispose();
    }

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

  Future<void> shareFiles() async {
    List<String> files = clips.map((e) => e.url).toList();

    bool isShared = await _storageService.shareFiles(files);
    if (!isShared) {
      _dialogService
          .showMessageError('Ocorreu um problema ao compartilhar os vídeos.');
    }
  }

  void dispose() {
    if (playerController != null) {
      playerController!.dispose();
    }

    for (Clip clip in clips) {
      _storageService.deleteFile(clip.url);
    }

    if (_cachedFile != '') {
      _storageService.deleteFile(_cachedFile);
    }
  }
}
