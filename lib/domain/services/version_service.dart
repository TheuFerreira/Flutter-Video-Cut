abstract class VersionService {
  Future<bool> hasUpdate();
  void updateApp();
  Future<String> getVersion();
}
