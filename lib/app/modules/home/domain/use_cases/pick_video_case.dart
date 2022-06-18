import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_video_cut/app/modules/home/domain/services/gallery_service.dart';
import 'package:image_picker/image_picker.dart';

abstract class PickVideoCase {
  Future<String?> call();
}

class PickVideoCaseImpl implements PickVideoCase {
  final GalleryService galleryService;

  PickVideoCaseImpl(this.galleryService);

  @override
  Future<String?> call() async {
    try {
      final file = await galleryService.pickVideo();
      /*final _picker = ImagePicker();
      final video = await _picker.pickVideo(source: ImageSource.gallery);
      final path = video?.path;*/
      final path = file?.path;
      return path;
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on Pick Video');
      rethrow;
    }
  }
}
