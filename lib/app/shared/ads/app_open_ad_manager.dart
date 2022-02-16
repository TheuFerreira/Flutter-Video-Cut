import 'dart:developer';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  String _adUnitAd = 'ca-app-pub-2801250254321156/4305166817';

  AppOpenAdManager() {
    if (kDebugMode) {
      _adUnitAd = 'ca-app-pub-3940256099942544/3419835294';
    }
  }

  Future loadAd() async {
    await AppOpenAd.load(
      adUnitId: _adUnitAd,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show();
          ad.dispose();
        },
        onAdFailedToLoad: (error) {
          log('AppOpenAd failed to load: $error');
        },
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
  }
}
