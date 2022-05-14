import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    String cachePath;

    try {
      cachePath = await _storageService.getCachePath();
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Error on Get Cache Path',
      );
      return;
    }

    final values = url.split('.');
    final extension = values[values.length - 1];
    _cachedFile = '$cachePath/cachedFile.$extension';

    try {
      _storageService.copyFile(url, _cachedFile);
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Error on copy original file to cache Path',
      );
      return;
    }

    List<String>? videosCuted;
    try {
      videosCuted =
          await _videoService.cutVideo(url: _cachedFile, destiny: cachePath);
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Error on cut video in clips',
      );
      return;
    }

    if (videosCuted == null) {
      return;
    }

    for (String videoCuted in videosCuted) {
      Uint8List thumbnail;
      try {
        thumbnail = await _videoService.getThumbnail(videoCuted);
      } catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: 'Error on get thubmnail of video',
        );
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

    try {
      _storageService.shareFiles(files);
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Error on share files',
      );
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
