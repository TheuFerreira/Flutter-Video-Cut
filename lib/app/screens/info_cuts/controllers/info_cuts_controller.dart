import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/components/clip_thumbnail_widget.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/player_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/enums/playback_type.dart';
import 'package:flutter_video_cut/app/screens/share/share_page.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:mobx/mobx.dart';

part 'info_cuts_controller.g.dart';

class InfoCutsController = _InfoCutsControllerBase with _$InfoCutsController;

abstract class _InfoCutsControllerBase with Store {
  final listKey = GlobalKey<AnimatedListState>();

  @observable
  List<CutModel> cuts = ObservableList<CutModel>();

  @observable
  int selected = 0;

  PlaybackType playbackType = PlaybackType.repeate;

  @computed
  String get pathSelectedCut => cuts[selected].path;

  final PlayerController _player;
  final IFileService _fileService = FileService();

  _InfoCutsControllerBase(this.cuts, this._player) {
    _loadClip();

    _player.onEnded = nextClip;
  }

  Future refreshListOfClips(List<CutModel> newCuts) async {
    while (cuts.isNotEmpty) {
      _deleteClip(0);
      await _fileService.deleteIfExists(cuts[0].path);
      cuts.removeAt(0);
    }

    for (CutModel cut in newCuts) {
      _addClip(cut);
    }

    selectClip(0);
  }

  void _addClip(CutModel newCut) {
    cuts.add(newCut);
    listKey.currentState!.insertItem(cuts.length - 1);
  }

  @action
  Future deleteClip(BuildContext context) async {
    _deleteClip(selected);

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

  void _deleteClip(int index) {
    listKey.currentState!.removeItem(
      index,
      (context, animation) {
        return SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          axis: Axis.horizontal,
          child: ClipThumbnailWidget(
            index,
            cuts[index],
          ),
        );
      },
    );
  }

  @action
  Future selectPreviousClip() async {
    await selectClip(selected - 1);
  }

  @action
  Future nextClip() async {
    if (playbackType != PlaybackType.loop) {
      return;
    }

    int nextClip = selected + 1;
    if (nextClip == cuts.length) {
      nextClip = 0;
    }
    await selectClip(nextClip);
    await _player.playPause();
  }

  @action
  Future selectNextClip() async {
    await selectClip(selected + 1);
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

  Future shareCuts(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SharePage(cuts),
        transitionsBuilder: (context, animation, _, child) {
          const begin =  Offset(1, 0);
          const end = Offset(0, 0);

          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
