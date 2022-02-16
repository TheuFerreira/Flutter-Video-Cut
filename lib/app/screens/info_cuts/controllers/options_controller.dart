import 'package:flutter/cupertino.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/info_cuts_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/player_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/models/playback_speed.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:mobx/mobx.dart';

part 'options_controller.g.dart';

class OptionsController = _OptionsControllerBase with _$OptionsController;

abstract class _OptionsControllerBase with Store {
  @observable
  PlaybackSpeed? playbackSpeed;
  int _selectedSpeed = 0;

  List<PlaybackSpeed> speeds = ObservableList<PlaybackSpeed>.of(const [
    PlaybackSpeed('1x', 1),
    PlaybackSpeed('1.5x', 1.5),
    PlaybackSpeed('2x', 2),
  ]);

  final InfoCutsController _infoCutsController;
  final PlayerController _playerController;

  _OptionsControllerBase(this._infoCutsController, this._playerController) {
    playbackSpeed = speeds[_selectedSpeed];
  }

  Future deleteButton(BuildContext context) async {
    final clipSelected = _infoCutsController.selected + 1;
    final result = await DialogService.showConfirmationDialog(
      context,
      'Tem certeza de que deseja excluir o Clip $clipSelected? Esta ação não poderá ser desfeita!',
    );

    if (result == false) {
      return;
    }

    _infoCutsController.deleteClip(context);
  }

  @action
  Future nextPlaybackSpeed() async {
    _selectedSpeed++;
    if (_selectedSpeed == speeds.length) {
      _selectedSpeed = 0;
    }

    playbackSpeed = speeds[_selectedSpeed];
    await _playerController.setPlaybackSpeed(playbackSpeed!.value);
  }
}