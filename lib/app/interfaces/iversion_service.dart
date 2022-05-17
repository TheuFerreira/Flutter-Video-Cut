abstract class IVersionService {
  Future<bool> hasUpdate();
  void updateApp();
}
