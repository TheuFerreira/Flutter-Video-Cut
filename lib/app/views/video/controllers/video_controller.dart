import 'dart:io';

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
  @observable
  List<Clip> clips = ObservableList<Clip>();

  @observable
  VideoPlayerController? playerController;

  @observable
  bool isLoaded = false;

  final IVideoService _videoService = VideoService();
  final IStorageService _storageService = StorageService();

  @action
  Future<void> cutVideo(String url) async {
    final cachePath = await _storageService.getCachePath();

    final videosCuted =
        await _videoService.cutVideo(url: url, destiny: cachePath);
    if (videosCuted == null) {
      return;
    }

    for (String videoCuted in videosCuted) {
      final thumbnail = await _videoService.getThumbnail(videoCuted);
      Clip clip = Clip(url: videoCuted, thumbnail: thumbnail);
      clips.add(clip);
    }

    loadFile(clips[0].url);
  }

  Future<void> loadFile(String url) async {
    isLoaded = false;

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
}
