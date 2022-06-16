// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VideoController on _VideoControllerBase, Store {
  Computed<bool>? _$isFirstClipComputed;

  @override
  bool get isFirstClip =>
      (_$isFirstClipComputed ??= Computed<bool>(() => super.isFirstClip,
              name: '_VideoControllerBase.isFirstClip'))
          .value;
  Computed<bool>? _$isLastClipComputed;

  @override
  bool get isLastClip =>
      (_$isLastClipComputed ??= Computed<bool>(() => super.isLastClip,
              name: '_VideoControllerBase.isLastClip'))
          .value;
  Computed<double>? _$totalTimeComputed;

  @override
  double get totalTime =>
      (_$totalTimeComputed ??= Computed<double>(() => super.totalTime,
              name: '_VideoControllerBase.totalTime'))
          .value;

  late final _$clipsAtom =
      Atom(name: '_VideoControllerBase.clips', context: context);

  @override
  List<Clip> get clips {
    _$clipsAtom.reportRead();
    return super.clips;
  }

  @override
  set clips(List<Clip> value) {
    _$clipsAtom.reportWrite(value, super.clips, () {
      super.clips = value;
    });
  }

  late final _$selectedClipAtom =
      Atom(name: '_VideoControllerBase.selectedClip', context: context);

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

  late final _$isPlayingAtom =
      Atom(name: '_VideoControllerBase.isPlaying', context: context);

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

  late final _$currentTimeAtom =
      Atom(name: '_VideoControllerBase.currentTime', context: context);

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

  late final _$playerControllerAtom =
      Atom(name: '_VideoControllerBase.playerController', context: context);

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

  late final _$isLoadedAtom =
      Atom(name: '_VideoControllerBase.isLoaded', context: context);

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

  late final _$cutVideoAsyncAction =
      AsyncAction('_VideoControllerBase.cutVideo', context: context);

  @override
  Future<void> cutVideo(String url, int secondsOfClip, BuildContext context) {
    return _$cutVideoAsyncAction
        .run(() => super.cutVideo(url, secondsOfClip, context));
  }

  late final _$deleteClipAsyncAction =
      AsyncAction('_VideoControllerBase.deleteClip', context: context);

  @override
  Future<void> deleteClip(BuildContext context) {
    return _$deleteClipAsyncAction.run(() => super.deleteClip(context));
  }

  late final _$selectClipAsyncAction =
      AsyncAction('_VideoControllerBase.selectClip', context: context);

  @override
  Future<void> selectClip(int index) {
    return _$selectClipAsyncAction.run(() => super.selectClip(index));
  }

  late final _$loadFileAsyncAction =
      AsyncAction('_VideoControllerBase.loadFile', context: context);

  @override
  Future<void> loadFile(String url) {
    return _$loadFileAsyncAction.run(() => super.loadFile(url));
  }

  late final _$resumeVideoAsyncAction =
      AsyncAction('_VideoControllerBase.resumeVideo', context: context);

  @override
  Future<void> resumeVideo() {
    return _$resumeVideoAsyncAction.run(() => super.resumeVideo());
  }

  late final _$_VideoControllerBaseActionController =
      ActionController(name: '_VideoControllerBase', context: context);

  @override
  void previousClip() {
    final _$actionInfo = _$_VideoControllerBaseActionController.startAction(
        name: '_VideoControllerBase.previousClip');
    try {
      return super.previousClip();
    } finally {
      _$_VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextClip() {
    final _$actionInfo = _$_VideoControllerBaseActionController.startAction(
        name: '_VideoControllerBase.nextClip');
    try {
      return super.nextClip();
    } finally {
      _$_VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCurrentTime(dynamic _) {
    final _$actionInfo = _$_VideoControllerBaseActionController.startAction(
        name: '_VideoControllerBase.updateCurrentTime');
    try {
      return super.updateCurrentTime(_);
    } finally {
      _$_VideoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
clips: ${clips},
selectedClip: ${selectedClip},
isPlaying: ${isPlaying},
currentTime: ${currentTime},
playerController: ${playerController},
isLoaded: ${isLoaded},
isFirstClip: ${isFirstClip},
isLastClip: ${isLastClip},
totalTime: ${totalTime}
    ''';
  }
}
