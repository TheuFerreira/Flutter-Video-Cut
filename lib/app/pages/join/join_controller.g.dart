// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$JoinController on JoinControllerBase, Store {
  Computed<bool>? _$hasSelectedComputed;

  @override
  bool get hasSelected =>
      (_$hasSelectedComputed ??= Computed<bool>(() => super.hasSelected,
              name: 'JoinControllerBase.hasSelected'))
          .value;

  late final _$selectedsAtom =
      Atom(name: 'JoinControllerBase.selecteds', context: context);

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

  late final _$clipsAtom =
      Atom(name: 'JoinControllerBase.clips', context: context);

  @override
  List<Clip> get clips {
    _$clipsAtom.reportRead();
    return super.clips;
  }

  @override
  set clips(List<Clip> value) {
    _$clipsAtom.reportWrite(value, super.clips, () {
      super.clips = value;
    });
  }

  late final _$JoinControllerBaseActionController =
      ActionController(name: 'JoinControllerBase', context: context);

  @override
  void tapClip(Clip clip) {
    final _$actionInfo = _$JoinControllerBaseActionController.startAction(
        name: 'JoinControllerBase.tapClip');
    try {
      return super.tapClip(clip);
    } finally {
      _$JoinControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$JoinControllerBaseActionController.startAction(
        name: 'JoinControllerBase.clear');
    try {
      return super.clear();
    } finally {
      _$JoinControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void join(BuildContext context) {
    final _$actionInfo = _$JoinControllerBaseActionController.startAction(
        name: 'JoinControllerBase.join');
    try {
      return super.join(context);
    } finally {
      _$JoinControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selecteds: ${selecteds},
clips: ${clips},
hasSelected: ${hasSelected}
    ''';
  }
}
