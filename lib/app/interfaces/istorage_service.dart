import 'dart:io';

abstract class IStorageService {
  Future<File?> pickVideo();
  Future<String> getCachePath();
  void deleteFile(String url);
  void copyFile(String url, String destiny);
  void shareFiles(List<String> files);
}
