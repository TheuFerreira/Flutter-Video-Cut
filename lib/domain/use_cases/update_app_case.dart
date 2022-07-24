import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/version_service.dart';

abstract class UpdateAppCase {
  void call();
}

class UpdateAppCaseImpl implements UpdateAppCase {
  final VersionService _versionService;
  final LogService _logService;

  UpdateAppCaseImpl(
    this._versionService,
    this._logService,
  );

  @override
  void call() {
    _logService.writeInfo('Updating App...');
    _versionService.updateApp();
  }
}
