import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class IStorageService {
  Future<File?> getVideoFromGallery();
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
}
