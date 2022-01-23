import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static void open(String url) async {
    await launch(url);
  }
}
