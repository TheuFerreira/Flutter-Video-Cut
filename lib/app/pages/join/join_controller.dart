import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/dialogs/dialog_service.dart';
import 'package:flutter_video_cut/app/dialogs/info_dialog.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/use_cases/delete_file_from_storage_case.dart';
import 'package:flutter_video_cut/domain/use_cases/get_thumbnail_case.dart';
import 'package:flutter_video_cut/domain/use_cases/join_clips_case.dart';
import 'package:mobx/mobx.dart';

part 'join_controller.g.dart';

class JoinController = JoinControllerBase with _$JoinController;

abstract class JoinControllerBase with Store {
  @computed
  bool get hasSelected => selecteds.length >= 2;

  @observable
  List<Clip> selecteds = ObservableList<Clip>();

  @observable
  List<Clip> clips = ObservableList<Clip>();

  final _joinClipsCase = Modular.get<JoinClipsCaseImpl>();
  final _deleteFileFromStorageCase = Modular.get<DeleteFileFromStorageCase>();
  final _getThumbnailCase = Modular.get<GetThumbnailCase>();

  final _infoDialog = InfoDialog();
  final _dialogService = DialogService();

  JoinControllerBase(this.clips);

  @action
  void tapClip(Clip clip) {
    final containsClip = selecteds.contains(clip);
    if (containsClip) {
      selecteds.remove(clip);
      return;
    }

    selecteds.add(clip);
  }

  @action
  void clear() => selecteds.clear();

  @action
  void join(BuildContext context) {
    if (!hasSelected) {
      return;
    }

    _join(context);
  }

  _join(BuildContext context) async {
    List<Clip> clipsCopy = [];
    try {
      _infoDialog.show(
        context,
        text: 'Estamos unindo seus clips selecionados...',
      );

      selecteds.sort((a, b) => a.index.compareTo(b.index));

      final newClip = await _joinClipsCase(selecteds);
      newClip.thumbnail = await _getThumbnailCase(newClip.url);
      clipsCopy = List<Clip>.from(clips);

      clipsCopy.add(newClip);
      clipsCopy.removeWhere((element) => selecteds.contains(element));
      selecteds.forEach(_deleteSelectedClipFromStorage);

      clipsCopy.sort((a, b) => a.index.compareTo(b.index));
    } catch (e, s) {
      _dialogService.showMessageError('Error on Join Clips');
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on Join Clips');
    } finally {
      _infoDialog.close();
    }

    if (clipsCopy.isEmpty) {
      return;
    }

    Navigator.of(context).pop(clipsCopy);
  }

  _deleteSelectedClipFromStorage(Clip clip) {
    _deleteFileFromStorageCase(clip.url);
  }
}
