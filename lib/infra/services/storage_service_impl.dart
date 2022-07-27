import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:gallery_saver/gallery_saver.dart';

class StorageServiceImpl implements StorageService {
  final _methodChannel = const MethodChannel('com.example.flutter_video_cut.path');

  @override
  void deleteFile(String url) {
    final file = File(url);
    file.deleteSync();
  }

  @override
  Future<void> copyFile(String url, String destiny) async {
    final file = File(url);
    await file.copy(destiny);
  }

  @override
  Future<void> saveInGallery(String path) async => await GallerySaver.saveVideo(path, albumName: 'Video Cut');

  @override
  Future<void> shareFiles(List<String> files) async {
    await _methodChannel.invokeMethod('shareFiles', files);
    return;
  }

  @override
  bool checkFileExists(String url) {
    final file = File(url);
    final exists = file.existsSync();
    return exists;
  }
}
