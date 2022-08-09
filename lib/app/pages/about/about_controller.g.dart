// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AboutController on _AboutControllerBase, Store {
  late final _$versionAtom =
      Atom(name: '_AboutControllerBase.version', context: context);

  @override
  String get version {
    _$versionAtom.reportRead();
    return super.version;
  }

  @override
  set version(String value) {
    _$versionAtom.reportWrite(value, super.version, () {
      super.version = value;
    });
  }

  late final _$_AboutControllerBaseActionController =
      ActionController(name: '_AboutControllerBase', context: context);

  @override
  void openUrl(String url) {
    final _$actionInfo = _$_AboutControllerBaseActionController.startAction(
        name: '_AboutControllerBase.openUrl');
    try {
      return super.openUrl(url);
    } finally {
      _$_AboutControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkForUpdates(BuildContext context) {
    final _$actionInfo = _$_AboutControllerBaseActionController.startAction(
        name: '_AboutControllerBase.checkForUpdates');
    try {
      return super.checkForUpdates(context);
    } finally {
      _$_AboutControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getAppVersion() {
    final _$actionInfo = _$_AboutControllerBaseActionController.startAction(
        name: '_AboutControllerBase.getAppVersion');
    try {
      return super.getAppVersion();
    } finally {
      _$_AboutControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
version: ${version}
    ''';
  }
}
