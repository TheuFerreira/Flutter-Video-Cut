import 'package:flutter_video_cut/domain/services/version_service.dart';
import 'package:flutter_video_cut/domain/errors/version_errors.dart';

abstract class CheckAppVersionCase {
  Future<void> call();
}

class CheckAppVersionCaseImpl implements CheckAppVersionCase {
  final VersionService _versionService;

  CheckAppVersionCaseImpl(this._versionService);

  @override
  Future<void> call() async {
    final hasUpdate = await _versionService.hasUpdate();
    if (!hasUpdate) {
      throw AppDontHaveUpdateException();
    }
  }
}
