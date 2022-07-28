import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/dialogs/dialog_service.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/use_cases/share_clips_case.dart';
import 'package:mobx/mobx.dart';

part 'share_controller.g.dart';

class ShareController = ShareControllerBase with _$ShareController;

abstract class ShareControllerBase with Store {
  @computed
  bool get hasSelected => selecteds.isNotEmpty;

  @observable
  List<Clip> selecteds = ObservableList<Clip>();

  final _shareClipsCase = Modular.get<ShareClipsCase>();
  final _dialogService = DialogService();

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
  void share() => _share();

  _share() async {
    try {
      selecteds.sort((a, b) => a.index.compareTo(b.index));

      await _shareClipsCase(selecteds);
    } catch (e) {
      _dialogService.showMessageError('Erro ao compartilhar vídeos');
    }
  }
}
