// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  late final _$isSearchingAtom =
      Atom(name: '_HomeControllerBase.isSearching', context: context);

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  late final _$searchVideoAsyncAction =
      AsyncAction('_HomeControllerBase.searchVideo', context: context);

  @override
  Future<void> searchVideo(BuildContext context) {
    return _$searchVideoAsyncAction.run(() => super.searchVideo(context));
  }

  @override
  String toString() {
    return '''
isSearching: ${isSearching}
    ''';
  }
}
