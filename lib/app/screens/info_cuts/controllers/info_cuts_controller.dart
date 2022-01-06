import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:mobx/mobx.dart';
import 'package:share_plus/share_plus.dart';

part 'info_cuts_controller.g.dart';

class InfoCutsController = _InfoCutsControllerBase with _$InfoCutsController;

abstract class _InfoCutsControllerBase with Store {
  @observable
  List<CutModel> cuts = ObservableList<CutModel>();

  @observable
  int selected = 0;

  _InfoCutsControllerBase(this.cuts);

  @action
  Future shareCuts() async {
    List<String> paths = _getPaths();
    await Share.shareFiles(paths);
  }

  List<String> _getPaths() {
    List<String> paths = [];
    for (var element in cuts) {
      paths.add(element.path);
    }
    return paths;
  }

  @action
  void selectClip(int index) {
    selected = index;
  }
}
