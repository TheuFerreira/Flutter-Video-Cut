import 'package:flutter_video_cut/domain/services/version_service.dart';

abstract class UpdateAppCase {
  void call();
}

class UpdateAppCaseImpl implements UpdateAppCase {
  final VersionService _versionService;

  UpdateAppCaseImpl(this._versionService);

  @override
  void call() {
    _versionService.updateApp();
  }
}
