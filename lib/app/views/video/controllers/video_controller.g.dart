// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VideoController on _VideoControllerBase, Store {
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

  late final _$loadFileAsyncAction =
      AsyncAction('_VideoControllerBase.loadFile', context: context);

  @override
  Future<void> loadFile(String url) {
    return _$loadFileAsyncAction.run(() => super.loadFile(url));
  }

  @override
  String toString() {
    return '''
playerController: ${playerController},
isLoaded: ${isLoaded}
    ''';
  }
}
