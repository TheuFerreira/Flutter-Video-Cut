import 'dart:io';

abstract class IStorageService {
  Future<File?> pickVideo();
  Future<String?> getCachePath();
  void deleteFile(String url);
  Future<bool> copyFile(String url, String destiny);
  Future<bool> shareFiles(List<String> files);
}
