// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VideoController on VideoControllerBase, Store {
  Computed<bool>? _$isFirstClipComputed;

  @override
  bool get isFirstClip =>
      (_$isFirstClipComputed ??= Computed<bool>(() => super.isFirstClip,
              name: 'VideoControllerBase.isFirstClip'))
          .value;
  Computed<bool>? _$isLastClipComputed;

  @override
  bool get isLastClip =>
      (_$isLastClipComputed ??= Computed<bool>(() => super.isLastClip,
              name: 'VideoControllerBase.isLastClip'))
          .value;

  late final _$isLoadedAtom =
      Atom(name: 'VideoControllerBase.isLoaded', context: context);

  @override
  bool get isLoaded {
    _$isLoadedAtom.reportRead();
    return super.isLoaded;
  }

  @override
  set isLoaded(bool value) {
    _$isLoadedAtom.reportWrite(value, super.isLoaded, () {
      super.isLoaded = value;
    });
  }

  late final _$clipsAtom =
      Atom(name: 'VideoControllerBase.clips', context: context);

  @override
  ObservableList<Clip> get clips {
    _$clipsAtom.reportRead();
    return super.clips;
  }

  @override
  set clips(ObservableList<Clip> value) {
    _$clipsAtom.reportWrite(value, super.clips, () {
      super.clips = value;
    });
  }

  late final _$selectedClipAtom =
      Atom(name: 'VideoControllerBase.selectedClip', context: context);

  @override
  int get selectedClip {
    _$selectedClipAtom.reportRead();
    return super.selectedClip;
  }

  @override
  set selectedClip(int value) {
    _$selectedClipAtom.reportWrite(value, super.selectedClip, () {
      super.selectedClip = value;
    });
  }

  late final _$playbackTypeAtom =
      Atom(name: 'VideoControllerBase.playbackType', context: context);

  @override
  PlaybackType get playbackType {
    _$playbackTypeAtom.reportRead();
    return super.playbackType;
  }

  @override
  set playbackType(PlaybackType value) {
    _$playbackTypeAtom.reportWrite(value, super.playbackType, () {
      super.playbackType = value;
    });
  }

  late final _$playbackSpeedAtom =
      Atom(name: 'VideoControllerBase.playbackSpeed', context: context);

  @override
  PlaybackSpeed get playbackSpeed {
    _$playbackSpeedAtom.reportRead();
    return super.playbackSpeed;
  }

  @override
  set playbackSpeed(PlaybackSpeed value) {
    _$playbackSpeedAtom.reportWrite(value, super.playbackSpeed, () {
      super.playbackSpeed = value;
    });
  }

  late final _$currentTimeAtom =
      Atom(name: 'VideoControllerBase.currentTime', context: context);

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

  late final _$totalTimeAtom =
      Atom(name: 'VideoControllerBase.totalTime', context: context);

  @override
  double get totalTime {
    _$totalTimeAtom.reportRead();
    return super.totalTime;
  }

  @override
  set totalTime(double value) {
    _$totalTimeAtom.reportWrite(value, super.totalTime, () {
      super.totalTime = value;
    });
  }

  late final _$playerControllerAtom =
      Atom(name: 'VideoControllerBase.playerController', context: context);

  @override
  VideoPlayerController? get playerController {
    _$playerControllerAtom.reportRead();
    return super.playerController;
  }

  @override
  set playerController(VideoPlayerController? value) {
    _$playerControllerAtom.reportWrite(value, super.playerController, () {
      super.playerController = value;
    });
  }

  late final _$VideoControllerBaseActionController =
      ActionController(name: 'VideoControllerBase', context: context);

  @override
  void start(List<Clip> tempClips) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.start');
    try {
      return super.start(tempClips);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectClip(Clip clip) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.selectClip');
    try {
      return super.selectClip(clip);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousClip() {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.previousClip');
    try {
      return super.previousClip();
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextClip() {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.nextClip');
    try {
      return super.nextClip();
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resumeVideo() {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.resumeVideo');
    try {
      return super.resumeVideo();
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changePlaybackType() {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.changePlaybackType');
    try {
      return super.changePlaybackType();
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changePlaybackSpeed() {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.changePlaybackSpeed');
    try {
      return super.changePlaybackSpeed();
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startChangeTrack(double newValue) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.startChangeTrack');
    try {
      return super.startChangeTrack(newValue);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void endChangeTrack(double newValue) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.endChangeTrack');
    try {
      return super.endChangeTrack(newValue);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeTrack(double newValue) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.changeTrack');
    try {
      return super.changeTrack(newValue);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteClip(BuildContext context) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.deleteClip');
    try {
      return super.deleteClip(context);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteSelectedClip(BuildContext context, Clip clip) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.deleteSelectedClip');
    try {
      return super.deleteSelectedClip(context, clip);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveFileInGallery(BuildContext context) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.saveFileInGallery');
    try {
      return super.saveFileInGallery(context);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveSelectedFileInGallery(BuildContext context, Clip clip) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.saveSelectedFileInGallery');
    try {
      return super.saveSelectedFileInGallery(context, clip);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void joinClips(BuildContext context) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.joinClips');
    try {
      return super.joinClips(context);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic shareClip(Clip clip) {
    final _$actionInfo = _$VideoControllerBaseActionController.startAction(
        name: 'VideoControllerBase.shareClip');
    try {
      return super.shareClip(clip);
    } finally {
      _$VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoaded: ${isLoaded},
clips: ${clips},
selectedClip: ${selectedClip},
playbackType: ${playbackType},
playbackSpeed: ${playbackSpeed},
currentTime: ${currentTime},
totalTime: ${totalTime},
playerController: ${playerController},
isFirstClip: ${isFirstClip},
isLastClip: ${isLastClip}
    ''';
  }
}
