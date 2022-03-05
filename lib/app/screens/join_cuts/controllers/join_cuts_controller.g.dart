// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_cuts_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$JoinCutsController on _JoinCutsControllerBase, Store {
  Computed<bool>? _$hasSelectedComputed;

  @override
  bool get hasSelected =>
      (_$hasSelectedComputed ??= Computed<bool>(() => super.hasSelected,
              name: '_JoinCutsControllerBase.hasSelected'))
          .value;

  final _$selectedCutsAtom = Atom(name: '_JoinCutsControllerBase.selectedCuts');

  @override
  List<CutModel> get selectedCuts {
    _$selectedCutsAtom.reportRead();
    return super.selectedCuts;
  }

  @override
  set selectedCuts(List<CutModel> value) {
    _$selectedCutsAtom.reportWrite(value, super.selectedCuts, () {
      super.selectedCuts = value;
    });
  }

  final _$joinClipsAsyncAction =
      AsyncAction('_JoinCutsControllerBase.joinClips');

  @override
  Future<void> joinClips(BuildContext context) {
    return _$joinClipsAsyncAction.run(() => super.joinClips(context));
  }

  final _$_JoinCutsControllerBaseActionController =
      ActionController(name: '_JoinCutsControllerBase');

  @override
  void clickCut(CutModel cut) {
    final _$actionInfo = _$_JoinCutsControllerBaseActionController.startAction(
        name: '_JoinCutsControllerBase.clickCut');
    try {
      return super.clickCut(cut);
    } finally {
      _$_JoinCutsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedCuts: ${selectedCuts},
hasSelected: ${hasSelected}
    ''';
  }
}
