// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ShareController on ShareControllerBase, Store {
  Computed<bool>? _$hasSelectedComputed;

  @override
  bool get hasSelected =>
      (_$hasSelectedComputed ??= Computed<bool>(() => super.hasSelected,
              name: 'ShareControllerBase.hasSelected'))
          .value;

  late final _$selectedsAtom =
      Atom(name: 'ShareControllerBase.selecteds', context: context);

  @override
  List<Clip> get selecteds {
    _$selectedsAtom.reportRead();
    return super.selecteds;
  }

  @override
  set selecteds(List<Clip> value) {
    _$selectedsAtom.reportWrite(value, super.selecteds, () {
      super.selecteds = value;
    });
  }

  late final _$ShareControllerBaseActionController =
      ActionController(name: 'ShareControllerBase', context: context);

  @override
  void tapClip(Clip clip) {
    final _$actionInfo = _$ShareControllerBaseActionController.startAction(
        name: 'ShareControllerBase.tapClip');
    try {
      return super.tapClip(clip);
    } finally {
      _$ShareControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$ShareControllerBaseActionController.startAction(
        name: 'ShareControllerBase.clear');
    try {
      return super.clear();
    } finally {
      _$ShareControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void share() {
    final _$actionInfo = _$ShareControllerBaseActionController.startAction(
        name: 'ShareControllerBase.share');
    try {
      return super.share();
    } finally {
      _$ShareControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selecteds: ${selecteds},
hasSelected: ${hasSelected}
    ''';
  }
}
