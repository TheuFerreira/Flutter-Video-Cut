// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  final _$cutVideoAsyncAction = AsyncAction('_HomeControllerBase.cutVideo');

  @override
  Future<List<CutModel>?> cutVideo(XFile video, int secondsByClip) {
    return _$cutVideoAsyncAction
        .run(() => super.cutVideo(video, secondsByClip));
  }

  final _$disposeCutsAsyncAction =
      AsyncAction('_HomeControllerBase.disposeCuts');

  @override
  Future<dynamic> disposeCuts(List<CutModel> cuts) {
    return _$disposeCutsAsyncAction.run(() => super.disposeCuts(cuts));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
