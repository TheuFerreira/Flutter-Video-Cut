import 'package:new_version/new_version.dart';

abstract class IVersionService {
  Future<bool> updateAvailable();
  Future<void> launchAppStore();
}

class VersionService implements IVersionService {
  final _newVersion = NewVersion();

  @override
  Future<void> launchAppStore() async {
    final version = await _newVersion.getVersionStatus();
    if (version == null) {
      return;
    }
    await _newVersion.launchAppStore(version.appStoreLink);
  }

  @override
  Future<bool> updateAvailable() async {
    final version = await _newVersion.getVersionStatus();
    if (version == null) {
      return false;
    }

    return version.canUpdate;
  }
}
