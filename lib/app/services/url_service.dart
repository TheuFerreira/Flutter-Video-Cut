import 'package:flutter_video_cut/app/interfaces/iurl_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlService implements IUrlService {
  @override
  Future<bool> openUrl(Uri uri) async {
    final result = await launchUrl(uri);
    return result;
  }
}
