import 'package:flutter_video_cut/domain/services/url_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlServiceImpl implements UrlService {
  @override
  Future<bool> openUrl(Uri uri) async {
    final result = await launchUrl(uri);
    return result;
  }
}
