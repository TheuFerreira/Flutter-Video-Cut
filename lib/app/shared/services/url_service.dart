import 'package:url_launcher/url_launcher.dart';

abstract class IUrlService {
  void open(String url);
}

class UrlService implements IUrlService {
  @override
  void open(String url) async {
    await launch(url);
  }
}
