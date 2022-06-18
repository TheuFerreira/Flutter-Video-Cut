import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/interfaces/idialog_service.dart';
import 'package:flutter_video_cut/app/modules/home/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/get_seconds_case.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/pick_video_case.dart';
import 'package:flutter_video_cut/app/services/dialog_service.dart';
import 'package:flutter_video_cut/app/views/video/video_page.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  bool isSearching = false;

  final _pickVideoCase = Modular.get<PickVideoCase>();
  final _getSecondsCase = Modular.get<GetSecondsCase>();

  final IDialogService _dialogService = DialogService();

  @action
  Future<void> searchVideo(BuildContext context) async {
    isSearching = true;

    try {
      final path = await _pickVideoCase();
      final secondsOfVideo = await _getSecondsCase(path);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) =>
              VideoPage(videoPath: path, secondsOfClip: secondsOfVideo),
        ),
      );
    } on HomeNotSelectedVideoException {
      return;
    } on HomeInvalidVideoException catch (e) {
      _dialogService.showMessageError(e.message);
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on Search Video');
      _dialogService.showMessageError('Um problema aconteceu');
    } finally {
      isSearching = false;
    }
  }
}
