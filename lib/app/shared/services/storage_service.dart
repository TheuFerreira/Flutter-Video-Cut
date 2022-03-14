import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

abstract class IStorageService {
  Future<File?> getVideoFromGallery();
  Future<bool> saveVideoInGallery(String originalFile, String newName);
}

class StorageService implements IStorageService {
  final _picker = ImagePicker();

  @override
  Future<File?> getVideoFromGallery() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) {
      return null;
    }

    final file = File(video.path);
    return file;
  }

  @override
  Future<bool> saveVideoInGallery(String originalFile, String newName) async {
    try {
      MethodChannel channel = const MethodChannel("com.example.flutter_video_cut.path");
      channel.invokeMethod('saveFileInGallery', [originalFile, newName]);
      return true;
    } on Exception {
      return false;
    }
  }
}
