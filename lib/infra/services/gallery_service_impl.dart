import 'dart:io';

import 'package:flutter_video_cut/domain/services/gallery_service.dart';
import 'package:image_picker/image_picker.dart';

class GalleryServiceImpl implements GalleryService {
  @override
  Future<File?> pickVideo() async {
    final _picker = ImagePicker();
    final video = await _picker.pickVideo(source: ImageSource.gallery);

    final file = video == null ? null : File(video.path);
    return file;
  }
}
