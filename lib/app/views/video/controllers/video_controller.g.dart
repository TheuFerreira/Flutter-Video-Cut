// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VideoController on _VideoControllerBase, Store {
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
  Future<void> cutVideo(String url) {
    return _$cutVideoAsyncAction.run(() => super.cutVideo(url));
  }

  late final _$resumeVideoAsyncAction =
      AsyncAction('_VideoControllerBase.resumeVideo', context: context);

  @override
  Future<void> resumeVideo() {
    return _$resumeVideoAsyncAction.run(() => super.resumeVideo());
  }

  @override
  String toString() {
    return '''
clips: ${clips},
playerController: ${playerController},
isLoaded: ${isLoaded}
    ''';
  }
}
