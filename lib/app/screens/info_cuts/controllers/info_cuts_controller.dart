import 'dart:io';

import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/directory_service.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:flutter_video_cut/app/shared/services/permission_service.dart';
import 'package:mobx/mobx.dart';
import 'package:share_plus/share_plus.dart';

part 'info_cuts_controller.g.dart';

class InfoCutsController = _InfoCutsControllerBase with _$InfoCutsController;

abstract class _InfoCutsControllerBase with Store {
  @observable
  List<CutModel> cuts = ObservableList<CutModel>();

  @observable
  int selected = 0;

  @observable
  bool deleted = false;

  @computed
  String get pathSelectedCut => cuts[selected].path;

  _InfoCutsControllerBase(this.cuts);

  @action
  Future<bool> shareCuts() async {
    if (await PermissionService().hasExternalStorage() == false) {
      return false;
    }

    final cutsPath = _getCutsPaths();
    final appCutsPath = await _setCutsPathInAppDirectory(cutsPath);

    await FileService().saveListTo(cutsPath, appCutsPath);

    return true;
    // TODO: Share Files
    //await Share.shareFiles(paths);
  }

  List<String> _getCutsPaths() {
    List<String> paths = [];
    for (var element in cuts) {
      paths.add(element.path);
    }

    return paths;
  }

  Future<List<String>> _setCutsPathInAppDirectory(List<String> cutsPath) async {
    Directory appDirectory = await DirectoryService.getAppDirectory();
    List<String> paths = [];

    for (String cutPath in cutsPath) {
      String fileName = FileService.getFileName(cutPath);
      paths.add(appDirectory.path + '/' + fileName);
    }

    return paths;
  }

  @action
  void selectClip(int index) {
    selected = index;
  }

  @action
  Future deleteClip(int index) async {
    deleted = true;

    await Future.delayed(const Duration(milliseconds: 100));

    await _deleteSelectedCut();
    deleted = false;

    if (cuts.isEmpty) {
      return -1;
    }

    return index == 0 ? index : index - 1;
  }

  _deleteSelectedCut() async {
    await FileService().deleteIfExists(pathSelectedCut);
    cuts.removeAt(selected);
  }
}
