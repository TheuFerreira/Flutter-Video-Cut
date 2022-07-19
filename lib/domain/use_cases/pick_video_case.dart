import 'package:flutter_video_cut/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/domain/services/gallery_service.dart';

abstract class PickVideoCase {
  Future<String> call();
}

class PickVideoCaseImpl implements PickVideoCase {
  final GalleryService galleryService;

  PickVideoCaseImpl(this.galleryService);

  @override
  Future<String> call() async {
    try {
      final file = await galleryService.pickVideo();
      if (file == null) {
        throw HomeNotSelectedVideoException();
      }

      final path = file.path;
      return path;
    } on HomeNotSelectedVideoException {
      rethrow;
    }
  }
}
