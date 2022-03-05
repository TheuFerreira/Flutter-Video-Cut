// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OptionsController on _OptionsControllerBase, Store {
  final _$playbackSpeedAtom =
      Atom(name: '_OptionsControllerBase.playbackSpeed');

  @override
  PlaybackSpeed? get playbackSpeed {
    _$playbackSpeedAtom.reportRead();
    return super.playbackSpeed;
  }

  @override
  set playbackSpeed(PlaybackSpeed? value) {
    _$playbackSpeedAtom.reportWrite(value, super.playbackSpeed, () {
      super.playbackSpeed = value;
    });
  }

  final _$playbackTypeAtom = Atom(name: '_OptionsControllerBase.playbackType');

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

  final _$nextPlaybackSpeedAsyncAction =
      AsyncAction('_OptionsControllerBase.nextPlaybackSpeed');

  @override
  Future<dynamic> nextPlaybackSpeed() {
    return _$nextPlaybackSpeedAsyncAction.run(() => super.nextPlaybackSpeed());
  }

  final _$joinClipsAsyncAction =
      AsyncAction('_OptionsControllerBase.joinClips');

  @override
  Future<void> joinClips(BuildContext context) {
    return _$joinClipsAsyncAction.run(() => super.joinClips(context));
  }

  final _$_OptionsControllerBaseActionController =
      ActionController(name: '_OptionsControllerBase');

  @override
  void nextPlaybackType() {
    final _$actionInfo = _$_OptionsControllerBaseActionController.startAction(
        name: '_OptionsControllerBase.nextPlaybackType');
    try {
      return super.nextPlaybackType();
    } finally {
      _$_OptionsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
playbackSpeed: ${playbackSpeed},
playbackType: ${playbackType}
    ''';
  }
}
