import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/interfaces/idialog_service.dart';
import 'package:flutter_video_cut/app/interfaces/ivideo_service.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/pick_video_case.dart';
import 'package:flutter_video_cut/app/services/dialog_service.dart';
import 'package:flutter_video_cut/app/services/video_service.dart';
import 'package:flutter_video_cut/app/views/video/video_page.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  bool isSearching = false;
  final _pickVideoCase = Modular.get<PickVideoCase>();
  final IVideoService _videoService = VideoService();
  final IDialogService _dialogService = DialogService();

  @action
  Future<void> searchVideo(BuildContext context) async {
    isSearching = true;

    String? path;

    try {
      path = await _pickVideoCase();
      if (path == null) {
        isSearching = false;
        return;
      }
    } on Exception {
      _dialogService.showMessageError('Um problema aconteceu');
      return;
    } finally {
      isSearching = false;
    }

    final secondsOfVideo = await _videoService.getSeconds(path);
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
            VideoPage(videoPath: path!, secondsOfClip: secondsOfVideo),
      ),
    );
  }
}
