// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  final _$statusPageAtom = Atom(name: '_HomeControllerBase.statusPage');

  @override
  Status get statusPage {
    _$statusPageAtom.reportRead();
    return super.statusPage;
  }

  @override
  set statusPage(Status value) {
    _$statusPageAtom.reportWrite(value, super.statusPage, () {
      super.statusPage = value;
    });
  }

  final _$messageAtom = Atom(name: '_HomeControllerBase.message');

  @override
  String get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
    });
  }

  final _$cutVideoAsyncAction = AsyncAction('_HomeControllerBase.cutVideo');

  @override
  Future<List<CutModel>?> cutVideo() {
    return _$cutVideoAsyncAction.run(() => super.cutVideo());
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
statusPage: ${statusPage},
message: ${message}
    ''';
  }
}
