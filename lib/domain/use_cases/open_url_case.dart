import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/url_service.dart';
import 'package:flutter_video_cut/domain/errors/url_exception.dart';

abstract class OpenUrlCase {
  Future<void> call(String url);
}

class OpenUrlCaseImpl implements OpenUrlCase {
  final UrlService _urlLauncher;
  final LogService _logService;

  OpenUrlCaseImpl(
    this._urlLauncher,
    this._logService,
  );

  @override
  Future<void> call(String url) async {
    _logService.writeInfo('Opening URL');
    final success = await _urlLauncher.openUrl(url);
    if (!success) {
      _logService.writeError('Error on open URL');
      throw UrlException();
    }
  }
}
