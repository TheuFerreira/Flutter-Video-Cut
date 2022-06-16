import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/interfaces/idialog_service.dart';
import 'package:flutter_video_cut/app/interfaces/istorage_service.dart';
import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';
import 'package:flutter_video_cut/app/services/dialog_service.dart';
import 'package:flutter_video_cut/app/services/storage_service.dart';
import 'package:flutter_video_cut/app/services/video_service.dart';
import 'package:flutter_video_cut/app/views/video/video_page.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  bool isSearching = false;
  final IStorageService _storageService = StorageService();
  final IVideoService _videoService = VideoService();
  final IDialogService _dialogService = DialogService();

  @action
  Future<void> searchVideo(BuildContext context) async {
    isSearching = true;

    final file = await _storageService.pickVideo();
    if (file == null) {
      isSearching = false;
      return;
    }

    final secondsOfVideo = await _videoService.getSeconds(file.path);
    isSearching = false;

    if (secondsOfVideo <= 10) {
      _dialogService
          .showMessageError('O limite mínimo é de 10 segundos por vídeo.');
      return;
    }

    double minutes = secondsOfVideo / 60.0;
    if (minutes > 5) {
      _dialogService
          .showMessageError('O limite máximo é de 5 minutos por vídeo.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) =>
            VideoPage(videoPath: file.path, secondsOfClip: secondsOfVideo),
      ),
    );
  }
}
