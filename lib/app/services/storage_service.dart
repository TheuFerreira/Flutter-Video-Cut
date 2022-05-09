import 'dart:io';

import 'package:flutter_video_cut/app/interfaces/istorage_service.dart';
import 'package:image_picker/image_picker.dart';

class StorageService implements IStorageService {
  @override
  Future<File?> pickVideo() async {
    final _picker = ImagePicker();
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) {
      return null;
    }

    File file = File(video.path);
    return file;
  }
}
