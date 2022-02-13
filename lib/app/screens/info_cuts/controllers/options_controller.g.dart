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

  final _$nextPlaybackSpeedAsyncAction =
      AsyncAction('_OptionsControllerBase.nextPlaybackSpeed');

  @override
  Future<dynamic> nextPlaybackSpeed() {
    return _$nextPlaybackSpeedAsyncAction.run(() => super.nextPlaybackSpeed());
  }

  @override
  String toString() {
    return '''
playbackSpeed: ${playbackSpeed}
    ''';
  }
}
