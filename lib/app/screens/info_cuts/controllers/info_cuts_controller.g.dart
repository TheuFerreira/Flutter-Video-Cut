// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_cuts_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InfoCutsController on _InfoCutsControllerBase, Store {
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

  final _$shareCutsAsyncAction =
      AsyncAction('_InfoCutsControllerBase.shareCuts');

  @override
  Future<dynamic> shareCuts() {
    return _$shareCutsAsyncAction.run(() => super.shareCuts());
  }

  @override
  String toString() {
    return '''
cuts: ${cuts}
    ''';
  }
}
