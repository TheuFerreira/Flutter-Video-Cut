abstract class IStorageService {
  Future<String?> getCachePath();
  void deleteFile(String url);
  Future<bool> copyFile(String url, String destiny);
  Future<bool> shareFiles(List<String> files);
}
