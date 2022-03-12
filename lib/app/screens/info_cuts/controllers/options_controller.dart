import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/components/popup_menu_widget.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/info_cuts_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/player_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/enums/playback_type.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/enums/popup_menu_type.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/models/playback_speed.dart';
import 'package:flutter_video_cut/app/screens/join_cuts/join_cuts_page.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/channel_service.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:mobx/mobx.dart';

part 'options_controller.g.dart';

class OptionsController = _OptionsControllerBase with _$OptionsController;

abstract class _OptionsControllerBase with Store {
  @observable
  PlaybackSpeed? playbackSpeed;
  int _selectedSpeed = 0;

  @observable
  PlaybackType playbackType = PlaybackType.repeate;

  List<PlaybackSpeed> speeds = ObservableList<PlaybackSpeed>.of(const [
    PlaybackSpeed('1x', 1),
    PlaybackSpeed('1.5x', 1.5),
    PlaybackSpeed('2x', 2),
  ]);

  final InfoCutsController _infoCutsController;
  final PlayerController _playerController;
  final IChannelService _channelService = ChannelService();

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

  @action
  void nextPlaybackType() {
    if (playbackType == PlaybackType.normal) {
      playbackType = PlaybackType.repeate;
      DialogService.showMessage('Repetir clipe atual');
    } else if (playbackType == PlaybackType.repeate) {
      playbackType = PlaybackType.loop;
      DialogService.showMessage('Repetir todos os clipes');
    } else if (playbackType == PlaybackType.loop) {
      playbackType = PlaybackType.normal;
      DialogService.showMessage('Reproduzir uma única vez');
    }

    _playerController.setIsLooping(playbackType == PlaybackType.repeate);
  }

  @action
  Future<void> joinClips(BuildContext context) async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (ctx, animation, secondaryAnimation) => JoinCutsPage(_infoCutsController.cuts),
        transitionsBuilder: (ctx, animation, _, child) {
          const begin = Offset(1, 0);
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
    if (result == null) {
      return;
    }

    List<CutModel> cuts = result as List<CutModel>;
    await _infoCutsController.refreshListOfClips(cuts);

    DialogService.showMessage('Clips unidos');
  }

  Future<void> showMenuOptions(BuildContext context, TapDownDetails details, CutModel cut) async {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    final result = await showMenu<PopupMenuType?>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: <PopupMenuEntry<PopupMenuType?>>[const PopupMenuWidget()],
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(120, 80),
        Offset.zero & overlay.size,
      ),
    );

    if (result == PopupMenuType.delete) {
      deleteButton(context);
    } else if (result == PopupMenuType.share) {
      List<String> paths = [cut.path];
      _channelService.shareFiles(paths);
    } else if (result == PopupMenuType.save) {
      // TODO: Save
    } else if (result == PopupMenuType.cutClip) {
      // TODO: Cut Clip
    }
  }
}
