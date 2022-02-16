import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/components/clip_thumbnail_widget.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/player_controller.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:flutter_video_cut/app/shared/services/share_service.dart';
import 'package:mobx/mobx.dart';

part 'info_cuts_controller.g.dart';

class InfoCutsController = _InfoCutsControllerBase with _$InfoCutsController;

abstract class _InfoCutsControllerBase with Store {
  final listKey = GlobalKey<AnimatedListState>();

  @observable
  List<CutModel> cuts = ObservableList<CutModel>();

  @observable
  int selected = 0;

  @computed
  String get pathSelectedCut => cuts[selected].path;

  final PlayerController _player;
  final IFileService _fileService = FileService();
  final IShareService _shareService = ShareService();

  _InfoCutsControllerBase(this.cuts, this._player) {
    _loadClip();
  }

  @action
  Future deleteClip(BuildContext context) async {
    listKey.currentState!.removeItem(
      selected,
      (context, animation) {
        return SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          axis: Axis.horizontal,
          child: ClipThumbnailWidget(
            selected,
            cuts[selected],
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await _fileService.deleteIfExists(pathSelectedCut);
    cuts.removeAt(selected);

    if (cuts.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final clipSelected = selected + 1;
    DialogService.showMessage('Clip $clipSelected deletado com sucesso');

    final nextIndex = selected == 0 ? selected : selected - 1;
    await selectClip(nextIndex);
  }

  @action
  Future selectClip(int index) async {
    selected = index;

    await _player.dispose();
    await _loadClip();
  }

  Future _loadClip() async {
    final clipPath = pathSelectedCut;
    await _player.loadClip(clipPath);

    _player.showPrevious = cuts.indexWhere((element) => element.path == clipPath) > 0;
    _player.showNext = cuts.indexWhere((element) => element.path == clipPath) != cuts.length - 1;
  }

  void shareCuts() {
    List<String> paths = [];
    for (var element in cuts) {
      paths.add(element.path);
    }

    _shareService.files(paths);
  }
}
