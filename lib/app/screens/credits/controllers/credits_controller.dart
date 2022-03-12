import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:flutter_video_cut/app/shared/services/url_service.dart';
import 'package:flutter_video_cut/app/shared/services/version_service.dart';
import 'package:mobx/mobx.dart';

part 'credits_controller.g.dart';

class CreditsController = _CreditsControllerBase with _$CreditsController;

abstract class _CreditsControllerBase with Store {
  final IUrlService urlService = UrlService();
  final IVersionService _versionService = VersionService();

  void open(String url) {
    urlService.open(url);
  }

  void checkForNewVersion(BuildContext context) async {
    final updateAvailable = await _versionService.updateAvailable();
    if (!updateAvailable) {
      DialogService.showInfoDialog(context, 'Você está na versão mais recente');
      return;
    }

    final result = await DialogService.showQuestionDialog(
      context,
      'Nova versão disponível',
      'Deseja atualizar o Video Cut?',
    );
    if (result != true) {
      return;
    }

    await _versionService.launchAppStore();
  }
}
