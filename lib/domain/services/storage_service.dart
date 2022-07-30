abstract class StorageService {
  void deleteFile(String url);
  Future<void> copyFile(String url, String destiny);
  Future<void> saveInGallery(String url);
  Future<void> shareFiles(List<String> files);
  bool checkFileExists(String url);
}
