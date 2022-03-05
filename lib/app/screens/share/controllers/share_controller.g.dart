// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ShareController on _ShareControllerBase, Store {
  Computed<bool>? _$hasSelectedComputed;

  @override
  bool get hasSelected =>
      (_$hasSelectedComputed ??= Computed<bool>(() => super.hasSelected,
              name: '_ShareControllerBase.hasSelected'))
          .value;

  final _$selectedCutsAtom = Atom(name: '_ShareControllerBase.selectedCuts');

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

  final _$_ShareControllerBaseActionController =
      ActionController(name: '_ShareControllerBase');

  @override
  void clickCut(CutModel cut) {
    final _$actionInfo = _$_ShareControllerBaseActionController.startAction(
        name: '_ShareControllerBase.clickCut');
    try {
      return super.clickCut(cut);
    } finally {
      _$_ShareControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void share(BuildContext context) {
    final _$actionInfo = _$_ShareControllerBaseActionController.startAction(
        name: '_ShareControllerBase.share');
    try {
      return super.share(context);
    } finally {
      _$_ShareControllerBaseActionController.endAction(_$actionInfo);
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
