import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_video_cut/app/interfaces/istorage_service.dart';
import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';
import 'package:flutter_video_cut/app/models/clip.dart';
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
  String _cachedFile = '';

  @action
  Future<void> cutVideo(String url) async {
    final cachePath = await _storageService.getCachePath();

    final values = url.split('.');
    final extension = values[values.length - 1];
    _cachedFile = '$cachePath/cachedFile.$extension';

    _storageService.copyFile(url, _cachedFile);

    final videosCuted =
        await _videoService.cutVideo(url: _cachedFile, destiny: cachePath);
    if (videosCuted == null) {
      return;
    }

    for (String videoCuted in videosCuted) {
      final thumbnail = await _videoService.getThumbnail(videoCuted);
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
