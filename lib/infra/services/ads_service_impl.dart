import 'dart:async';

import 'package:flutter_video_cut/domain/services/ads_service.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class ADSServiceImpl implements ADSService {
  final _streamController = StreamController<BannerAd?>();

  @override
  Stream get banner => _streamController.stream;
  BannerAd? _banner;

  final LogService _logService;

  ADSServiceImpl(this._logService);

  @override
  Future<void> loadBanner() async {
    String adUnitId = 'ca-app-pub-2801250254321156/1130895797';
    if (kDebugMode) {
      adUnitId = 'ca-app-pub-3940256099942544/6300978111';
    }

    _banner = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: _onAdLoaded,
        onAdFailedToLoad: _onAdFailedToLoad,
        onAdOpened: _onAdOpened,
        onAdClosed: _onAdClosed,
        onAdImpression: _onAdImpression,
      ),
      request: const AdRequest(),
    );

    await _banner!.load();
  }

  _onAdLoaded(Ad ad) {
    _streamController.add(_banner);
    _logService.writeInfo('Ad loaded.');
  }

  _onAdFailedToLoad(ad, error) {
    ad.dispose();
    _streamController.add(null);
    _logService.writeInfo('Ad failed to load: $error');
  }

  _onAdOpened(ad) => _logService.writeInfo('Ad opened.');
  _onAdClosed(ad) => _logService.writeInfo('Ad closed.');
  _onAdImpression(ad) => _logService.writeInfo('Ad impression');
}
