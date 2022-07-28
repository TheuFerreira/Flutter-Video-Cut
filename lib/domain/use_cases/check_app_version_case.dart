import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/version_service.dart';
import 'package:flutter_video_cut/domain/errors/version_errors.dart';

abstract class CheckAppVersionCase {
  Future<void> call();
}

class CheckAppVersionCaseImpl implements CheckAppVersionCase {
  final VersionService _versionService;
  final LogService _logService;

  CheckAppVersionCaseImpl(
    this._versionService,
    this._logService,
  );

  @override
  Future<void> call() async {
    _logService.writeInfo('Checking if app has a Update');
    final hasUpdate = await _versionService.hasUpdate();
    if (!hasUpdate) {
      _logService.writeError('App doesn\' have a Update');
      throw AppDontHaveUpdateException();
    }
  }
}
