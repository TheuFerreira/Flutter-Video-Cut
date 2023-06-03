// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on HomeControllerBase, Store {
  late final _$topBannerAtom =
      Atom(name: 'HomeControllerBase.topBanner', context: context);

  @override
  BannerAd? get topBanner {
    _$topBannerAtom.reportRead();
    return super.topBanner;
  }

  @override
  set topBanner(BannerAd? value) {
    _$topBannerAtom.reportWrite(value, super.topBanner, () {
      super.topBanner = value;
    });
  }

  late final _$HomeControllerBaseActionController =
      ActionController(name: 'HomeControllerBase', context: context);

  @override
  void load(BuildContext context) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.load');
    try {
      return super.load(context);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void searchVideo(BuildContext context) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.searchVideo');
    try {
      return super.searchVideo(context);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadBanner() {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.loadBanner');
    try {
      return super.loadBanner();
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
topBanner: ${topBanner}
    ''';
  }
}
