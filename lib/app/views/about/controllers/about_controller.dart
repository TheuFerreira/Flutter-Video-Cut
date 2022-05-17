import 'package:flutter/cupertino.dart';
import 'package:flutter_video_cut/app/interfaces/idialog_service.dart';
import 'package:flutter_video_cut/app/interfaces/iurl_service.dart';
import 'package:flutter_video_cut/app/interfaces/iversion_service.dart';
import 'package:flutter_video_cut/app/services/dialog_service.dart';
import 'package:flutter_video_cut/app/services/url_service.dart';
import 'package:flutter_video_cut/app/services/version_service.dart';
import 'package:mobx/mobx.dart';

part 'about_controller.g.dart';

class AboutController = _AboutControllerBase with _$AboutController;

abstract class _AboutControllerBase with Store {
  final IUrlService _urlLauncher = UrlService();
  final IDialogService _dialogService = DialogService();
  final IVersionService _versionService = VersionService();

  @action
  Future<void> openUrl(String url) async {
    Uri uri = Uri.parse(url);
    final success = await _urlLauncher.openUrl(uri);
    if (!success) {
      _dialogService.showMessage('Houve um problema ao acessar o site');
    }
  }

  @action
  Future<void> checkForUpdates(BuildContext context) async {
    final hasUpdate = await _versionService.hasUpdate();
    if (!hasUpdate) {
      _dialogService.showMessage('Você está na versão mais atual');
      return;
    }

    final confirm = await _dialogService.showQuestionDialog(
        context, 'Atualização disponível', 'Deseja atualizar o Video Cut?');
    if (!confirm) {
      return;
    }

    _versionService.updateApp();
  }
}
