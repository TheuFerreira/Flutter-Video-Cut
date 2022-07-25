import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/dialogs/info_dialog.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/use_cases/join_clips_case.dart';
import 'package:mobx/mobx.dart';

part 'join_controller.g.dart';

class JoinController = JoinControllerBase with _$JoinController;

abstract class JoinControllerBase with Store {
  @computed
  bool get hasSelected => selecteds.length == 2;

  @observable
  List<Clip> selecteds = ObservableList<Clip>();

  @observable
  List<Clip> clips = ObservableList<Clip>();

  final _joinClipsCase = Modular.get<JoinClipsCaseImpl>();

  final _infoDialog = InfoDialog();

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
    _infoDialog.show(
      context,
      text: 'Estamos unindo seus clips selecionados...',
    );

    selecteds.sort((a, b) => a.index.compareTo(b.index));

    final newClip = await _joinClipsCase(selecteds);
    final index = clips.indexOf(selecteds[0]);
    clips[index] = newClip;

    _infoDialog.close();
  }
}
