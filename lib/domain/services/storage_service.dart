abstract class StorageService {
  void deleteFile(String url);
  Future<void> copyFile(String url, String destiny);
  Future<void> shareFiles(List<String> files);
}
