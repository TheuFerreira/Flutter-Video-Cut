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

  final _$deleteClipAsyncAction =
      AsyncAction('_InfoCutsControllerBase.deleteClip');

  @override
  Future<dynamic> deleteClip(BuildContext context) {
    return _$deleteClipAsyncAction.run(() => super.deleteClip(context));
  }

  final _$selectPreviousClipAsyncAction =
      AsyncAction('_InfoCutsControllerBase.selectPreviousClip');

  @override
  Future<dynamic> selectPreviousClip() {
    return _$selectPreviousClipAsyncAction
        .run(() => super.selectPreviousClip());
  }

  final _$nextClipAsyncAction = AsyncAction('_InfoCutsControllerBase.nextClip');

  @override
  Future<dynamic> nextClip() {
    return _$nextClipAsyncAction.run(() => super.nextClip());
  }

  final _$selectNextClipAsyncAction =
      AsyncAction('_InfoCutsControllerBase.selectNextClip');

  @override
  Future<dynamic> selectNextClip() {
    return _$selectNextClipAsyncAction.run(() => super.selectNextClip());
  }

  final _$selectClipAsyncAction =
      AsyncAction('_InfoCutsControllerBase.selectClip');

  @override
  Future<dynamic> selectClip(int index) {
    return _$selectClipAsyncAction.run(() => super.selectClip(index));
  }

  @override
  String toString() {
    return '''
cuts: ${cuts},
selected: ${selected},
pathSelectedCut: ${pathSelectedCut}
    ''';
  }
}
