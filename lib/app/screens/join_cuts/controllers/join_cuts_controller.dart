import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:mobx/mobx.dart';

part 'join_cuts_controller.g.dart';

class JoinCutsController = _JoinCutsControllerBase with _$JoinCutsController;

abstract class _JoinCutsControllerBase with Store {
  @observable
  List<CutModel> selectedCuts = ObservableList<CutModel>();

  final List<CutModel> cuts;
  _JoinCutsControllerBase(this.cuts);

  @action
  void clickCut(CutModel cut) {
    final result = selectedCuts.contains(cut);
    if (result) {
      selectedCuts.remove(cut);
    } else {
      selectedCuts.add(cut);
    }
  }
}
