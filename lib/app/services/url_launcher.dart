import 'package:flutter_video_cut/app/interfaces/iurl_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher implements IUrlLauncher {
  @override
  Future<bool> openUrl(String url) async {
    final result = await launch(url);
    return result;
  }
}
