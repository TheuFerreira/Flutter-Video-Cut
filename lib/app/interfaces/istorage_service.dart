import 'dart:io';

abstract class IStorageService {
  Future<File?> pickVideo();
  Future<String> getCachePath();
  void deleteFile(String url);
}
