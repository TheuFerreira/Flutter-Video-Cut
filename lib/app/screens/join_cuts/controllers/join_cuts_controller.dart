import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/directory_service.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:flutter_video_cut/app/shared/services/thumbnail_service.dart';
import 'package:flutter_video_cut/app/shared/services/video_service.dart';
import 'package:mobx/mobx.dart';

part 'join_cuts_controller.g.dart';

class JoinCutsController = _JoinCutsControllerBase with _$JoinCutsController;

abstract class _JoinCutsControllerBase with Store {
  @observable
  List<CutModel> selectedCuts = ObservableList<CutModel>();

  @computed
  bool get hasSelected => selectedCuts.isNotEmpty;

  List<CutModel> cuts = ObservableList<CutModel>();
  final IThumbnailService _thumbnailService = ThumbnailService();
  final IDirectoryService _directoryService = DirectoryService();
  final IFileService _fileService = FileService();
  late IVideoService _videoService;

  _JoinCutsControllerBase(this.cuts) {
    _videoService = VideoService(_directoryService, _fileService);
  }

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
  Future<void> joinClips(BuildContext context) async {
    String contents = _getContents();

    final newFileName = await _getPathNewFileName();
    final pathListFile = await _generatePathTempListFile();
    final newFile = await _generateTempListFile(pathListFile, contents);
    final videoJoined = await _videoService.joinClips(pathListFile, newFileName);

    await newFile.delete();
    if (videoJoined == null) {
      return;
    }

    cuts = _copyListOfCuts();
    await _updateListCuts(videoJoined);

    Navigator.of(context).pop(cuts);
  }

  String _getContents() {
    String contents = "";
    for (CutModel cut in selectedCuts) {
      String value = "file '${cut.path}'\n";
      contents += value;
    }

    return contents;
  }

  Future<String> _getPathNewFileName() async {
    String tempPath = await _directoryService.getTemporaryPath();
    return tempPath + '/ola.mp4';
    ;
  }

  Future<String> _generatePathTempListFile() async {
    String tempPath = await _directoryService.getTemporaryPath();
    String tempListFile = tempPath + '/list.txt';
    return tempListFile;
  }

  Future<File> _generateTempListFile(String path, String contents) async {
    File newFile = File(path);
    await newFile.create();
    newFile = await newFile.writeAsString(contents);
    return newFile;
  }

  List<CutModel> _copyListOfCuts() {
    final List<CutModel> copyCuts = [];
    for (CutModel cutM in cuts) {
      copyCuts.add(cutM);
    }

    return copyCuts;
  }

  Future _updateListCuts(String newVideo) async {
    CutModel firstSelectedCut = selectedCuts.first;
    final indexFirstSelectedCut = cuts.indexOf(firstSelectedCut);

    CutModel cutJoined = await _generateCutModel(newVideo);
    cuts[indexFirstSelectedCut] = cutJoined;

    for (int i = 1; i < selectedCuts.length; i++) {
      cuts.remove(selectedCuts[i]);
    }
  }

  Future<CutModel> _generateCutModel(String path) async {
    final thumbnail = await _thumbnailService.getThumbnail(path);
    CutModel cut = CutModel(path, thumbnail);
    return cut;
  }
}
