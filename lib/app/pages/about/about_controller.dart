import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/dialogs/dialog_service.dart';
import 'package:flutter_video_cut/domain/errors/url_exception.dart';
import 'package:flutter_video_cut/domain/errors/version_errors.dart';
import 'package:flutter_video_cut/domain/use_cases/check_app_version_case.dart';
import 'package:flutter_video_cut/domain/use_cases/get_version_case.dart';
import 'package:flutter_video_cut/domain/use_cases/open_url_case.dart';
import 'package:flutter_video_cut/domain/use_cases/update_app_case.dart';
import 'package:mobx/mobx.dart';

part 'about_controller.g.dart';

class AboutController = _AboutControllerBase with _$AboutController;

abstract class _AboutControllerBase with Store {
  @observable
  String version = '';

  final _dialogService = DialogService();
  final _openUrlCase = Modular.get<OpenUrlCase>();
  final _checkAppVersionCase = Modular.get<CheckAppVersionCase>();
  final _updateAppCase = Modular.get<UpdateAppCase>();
  final _getVersionCase = Modular.get<GetVersionCase>();

  _AboutControllerBase() {
    getAppVersion();
  }

  @action
  void openUrl(String url) => _openUrl(url);
  _openUrl(String url) async {
    try {
      await _openUrlCase(url);
    } on UrlException {
      _dialogService.showMessage('Houve um problema ao acessar o site');
    }
  }

  @action
  void checkForUpdates(BuildContext context) => _checkForUpdates(context);
  _checkForUpdates(BuildContext context) async {
    try {
      await _checkAppVersionCase();

      final confirm = await _dialogService.showQuestionDialog(
          context, 'Atualização disponível', 'Deseja atualizar o Video Cut?');
      if (!confirm) {
        return;
      }

      _updateAppCase();
    } on AppDontHaveUpdateException {
      _dialogService.showMessage('Você está na versão mais atual');
    }
  }

  @action
  void getAppVersion() => _getAppVersion();
  _getAppVersion() async {
    version = await _getVersionCase();
  }
}
