import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/infra/utils/method_channel_name.dart';

class StorageServiceImpl implements StorageService {
  final _methodChannel = const MethodChannel(methodChannelName);

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
  Future<void> saveInGallery(String path) async {
    await _methodChannel.invokeMethod("saveInDCIM", path);
  }

  @override
  Future<void> shareFiles(List<String> files) async {
    await _methodChannel.invokeMethod('shareFiles', files);
  }

  @override
  bool checkFileExists(String url) {
    final file = File(url);
    final exists = file.existsSync();
    return exists;
  }
}
