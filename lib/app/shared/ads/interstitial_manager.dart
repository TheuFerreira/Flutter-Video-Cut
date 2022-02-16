import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialManager {
  String _adUnitId = 'ca-app-pub-2801250254321156/6297330367';

  InterstitialManager() {
    if (kDebugMode) {
      _adUnitId = 'ca-app-pub-3940256099942544/1033173712';
    }
  }

  Future loadAd() async {
    await InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show();
          ad.dispose();
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }
}
