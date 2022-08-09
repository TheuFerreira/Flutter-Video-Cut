import 'package:flutter_video_cut/domain/services/version_service.dart';
import 'package:new_version/new_version.dart';

class VersionServiceImpl implements VersionService {
  final _version = NewVersion();

  @override
  Future<bool> hasUpdate() async {
    final status = await _version.getVersionStatus();
    if (status == null) {
      return false;
    }

    final canUpdate = status.canUpdate;
    return canUpdate;
  }

  @override
  void updateApp() async {
    final status = await _version.getVersionStatus();
    _version.launchAppStore(status!.appStoreLink);
  }

  @override
  Future<String> getVersion() async {
    final version = await _version.getVersionStatus();
    return version!.localVersion;
  }
}
