import 'package:flutter_video_cut/domain/services/ads_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class LoadAdBannerCase {
  Future<BannerAd?> call();
}

class LoadAdBannerCaseImpl implements LoadAdBannerCase {
  final ADSService _adsService;

  LoadAdBannerCaseImpl(this._adsService);

  @override
  Future<BannerAd?> call() async {
    await _adsService.loadBanner();
    final banner = await _adsService.banner.first;
    return banner;
  }
}
