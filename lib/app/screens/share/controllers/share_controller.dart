import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/channel_service.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:mobx/mobx.dart';

part 'share_controller.g.dart';

class ShareController = _ShareControllerBase with _$ShareController;

abstract class _ShareControllerBase with Store {
  @observable
  List<CutModel> selectedCuts = ObservableList<CutModel>();

  @computed
  bool get hasSelected => selectedCuts.isNotEmpty;

  final List<CutModel> cuts;
  final int _shareLimit = 10;
  final IChannelService _channelService = ChannelService();

  _ShareControllerBase(this.cuts);

  @action
  void clickCut(BuildContext context, CutModel cut) {
    final result = selectedCuts.contains(cut);
    if (result) {
      selectedCuts.remove(cut);
      return;
    }

    if (selectedCuts.length >= _shareLimit) {
      DialogService.showInfoDialog(context, 'Só podem ser compartilhados no máximo 10 clips.');
      return;
    }

    selectedCuts.add(cut);
  }

  @action
  Future<void> share(BuildContext context) async {
    List<String> paths = [];
    for (CutModel element in selectedCuts) {
      paths.add(element.path);
    }

    final isShared = await _channelService.shareFiles(paths);
    if (isShared) {
      return;
    }

    FirebaseCrashlytics.instance.recordError(
      null,
      null,
      reason: 'Error on share videos',
      fatal: false,
    );
    DialogService.showMessage('Erro ao Compartilhar os vídeos');
  }
}
