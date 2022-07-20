import 'package:flutter_video_cut/domain/services/url_service.dart';
import 'package:flutter_video_cut/domain/errors/url_exception.dart';

abstract class OpenUrlCase {
  Future<void> call(String url);
}

class OpenUrlCaseImpl implements OpenUrlCase {
  final UrlService _urlLauncher;

  OpenUrlCaseImpl(this._urlLauncher);

  @override
  Future<void> call(String url) async {
    Uri uri = Uri.parse(url);
    final success = await _urlLauncher.openUrl(uri);
    if (!success) {
      throw UrlException();
    }
  }
}
