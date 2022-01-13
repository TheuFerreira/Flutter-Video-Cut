// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PlayerController on _PlayerControllerBase, Store {
  final _$stateAtom = Atom(name: '_PlayerControllerBase.state');

  @override
  PlayerState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(PlayerState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$isPlayingAtom = Atom(name: '_PlayerControllerBase.isPlaying');

  @override
  bool get isPlaying {
    _$isPlayingAtom.reportRead();
    return super.isPlaying;
  }

  @override
  set isPlaying(bool value) {
    _$isPlayingAtom.reportWrite(value, super.isPlaying, () {
      super.isPlaying = value;
    });
  }

  final _$showControllersAtom =
      Atom(name: '_PlayerControllerBase.showControllers');

  @override
  bool get showControllers {
    _$showControllersAtom.reportRead();
    return super.showControllers;
  }

  @override
  set showControllers(bool value) {
    _$showControllersAtom.reportWrite(value, super.showControllers, () {
      super.showControllers = value;
    });
  }

  final _$maxSecondsAtom = Atom(name: '_PlayerControllerBase.maxSeconds');

  @override
  double get maxSeconds {
    _$maxSecondsAtom.reportRead();
    return super.maxSeconds;
  }

  @override
  set maxSeconds(double value) {
    _$maxSecondsAtom.reportWrite(value, super.maxSeconds, () {
      super.maxSeconds = value;
    });
  }

  final _$currentTimeAtom = Atom(name: '_PlayerControllerBase.currentTime');

  @override
  double get currentTime {
    _$currentTimeAtom.reportRead();
    return super.currentTime;
  }

  @override
  set currentTime(double value) {
    _$currentTimeAtom.reportWrite(value, super.currentTime, () {
      super.currentTime = value;
    });
  }

  final _$selectedSpeedAtom = Atom(name: '_PlayerControllerBase.selectedSpeed');

  @override
  int get selectedSpeed {
    _$selectedSpeedAtom.reportRead();
    return super.selectedSpeed;
  }

  @override
  set selectedSpeed(int value) {
    _$selectedSpeedAtom.reportWrite(value, super.selectedSpeed, () {
      super.selectedSpeed = value;
    });
  }

  final _$loadClipAsyncAction = AsyncAction('_PlayerControllerBase.loadClip');

  @override
  Future<void> loadClip(String clipPath) {
    return _$loadClipAsyncAction.run(() => super.loadClip(clipPath));
  }

  final _$nextPlaybackSpeedAsyncAction =
      AsyncAction('_PlayerControllerBase.nextPlaybackSpeed');

  @override
  Future<dynamic> nextPlaybackSpeed() {
    return _$nextPlaybackSpeedAsyncAction.run(() => super.nextPlaybackSpeed());
  }

  final _$playPauseAsyncAction = AsyncAction('_PlayerControllerBase.playPause');

  @override
  Future<dynamic> playPause() {
    return _$playPauseAsyncAction.run(() => super.playPause());
  }

  final _$moveClipAsyncAction = AsyncAction('_PlayerControllerBase.moveClip');

  @override
  Future<dynamic> moveClip(double value) {
    return _$moveClipAsyncAction.run(() => super.moveClip(value));
  }

  final _$_PlayerControllerBaseActionController =
      ActionController(name: '_PlayerControllerBase');

  @override
  void updateControllers() {
    final _$actionInfo = _$_PlayerControllerBaseActionController.startAction(
        name: '_PlayerControllerBase.updateControllers');
    try {
      return super.updateControllers();
    } finally {
      _$_PlayerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
isPlaying: ${isPlaying},
showControllers: ${showControllers},
maxSeconds: ${maxSeconds},
currentTime: ${currentTime},
selectedSpeed: ${selectedSpeed}
    ''';
  }
}
