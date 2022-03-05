import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/share_service.dart';
import 'package:mobx/mobx.dart';

part 'share_controller.g.dart';

class ShareController = _ShareControllerBase with _$ShareController;

abstract class _ShareControllerBase with Store {
  @observable
  List<CutModel> selectedCuts = ObservableList<CutModel>();

  @computed
  bool get hasSelected => selectedCuts.isNotEmpty;

  final List<CutModel> cuts;
  final IShareService _shareService = ShareService();

  _ShareControllerBase(this.cuts);

  @action
  void clickCut(CutModel cut) {
    final result = selectedCuts.contains(cut);
    if (result) {
      selectedCuts.remove(cut);
    } else {
      selectedCuts.add(cut);
    }
  }

  @action
  void share(BuildContext context) {
    List<String> paths = [];
    for (var element in cuts) {
      paths.add(element.path);
    }

    _shareService.files(paths);
  }
}
