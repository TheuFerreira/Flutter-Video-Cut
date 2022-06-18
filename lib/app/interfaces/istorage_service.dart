abstract class IStorageService {
  void deleteFile(String url);
  Future<bool> copyFile(String url, String destiny);
  Future<bool> shareFiles(List<String> files);
}
