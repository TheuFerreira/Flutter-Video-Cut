import 'package:flutter_video_cut/domain/services/version_service.dart';

abstract class GetVersionCase {
  Future<String> call();
}

class GetVersionCaseImpl implements GetVersionCase {
  final VersionService _versionService;

  GetVersionCaseImpl(this._versionService);

  @override
  Future<String> call() async {
    final version = await _versionService.getVersion();
    return version;
  }
}
