// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_cuts_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InfoCutsController on _InfoCutsControllerBase, Store {
  Computed<String>? _$pathSelectedCutComputed;

  @override
  String get pathSelectedCut => (_$pathSelectedCutComputed ??= Computed<String>(
          () => super.pathSelectedCut,
          name: '_InfoCutsControllerBase.pathSelectedCut'))
      .value;

  final _$cutsAtom = Atom(name: '_InfoCutsControllerBase.cuts');

  @override
  List<CutModel> get cuts {
    _$cutsAtom.reportRead();
    return super.cuts;
  }

  @override
  set cuts(List<CutModel> value) {
    _$cutsAtom.reportWrite(value, super.cuts, () {
      super.cuts = value;
    });
  }

  final _$selectedAtom = Atom(name: '_InfoCutsControllerBase.selected');

  @override
  int get selected {
    _$selectedAtom.reportRead();
    return super.selected;
  }

  @override
  set selected(int value) {
    _$selectedAtom.reportWrite(value, super.selected, () {
      super.selected = value;
    });
  }

  final _$deletedAtom = Atom(name: '_InfoCutsControllerBase.deleted');

  @override
  bool get deleted {
    _$deletedAtom.reportRead();
    return super.deleted;
  }

  @override
  set deleted(bool value) {
    _$deletedAtom.reportWrite(value, super.deleted, () {
      super.deleted = value;
    });
  }

  final _$shareCutsAsyncAction =
      AsyncAction('_InfoCutsControllerBase.shareCuts');

  @override
  Future<dynamic> shareCuts() {
    return _$shareCutsAsyncAction.run(() => super.shareCuts());
  }

  final _$deleteClipAsyncAction =
      AsyncAction('_InfoCutsControllerBase.deleteClip');

  @override
  Future<dynamic> deleteClip(int index) {
    return _$deleteClipAsyncAction.run(() => super.deleteClip(index));
  }

  final _$_InfoCutsControllerBaseActionController =
      ActionController(name: '_InfoCutsControllerBase');

  @override
  void selectClip(int index) {
    final _$actionInfo = _$_InfoCutsControllerBaseActionController.startAction(
        name: '_InfoCutsControllerBase.selectClip');
    try {
      return super.selectClip(index);
    } finally {
      _$_InfoCutsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cuts: ${cuts},
selected: ${selected},
deleted: ${deleted},
pathSelectedCut: ${pathSelectedCut}
    ''';
  }
}
