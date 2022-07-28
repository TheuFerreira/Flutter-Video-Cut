import 'package:flutter_video_cut/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/domain/services/gallery_service.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';

abstract class PickVideoCase {
  Future<String> call();
}

class PickVideoCaseImpl implements PickVideoCase {
  final GalleryService galleryService;
  final LogService _logService;

  PickVideoCaseImpl(
    this.galleryService,
    this._logService,
  );

  @override
  Future<String> call() async {
    _logService.writeInfo('Picking a video...');
    final file = await galleryService.pickVideo();

    if (file == null) {
      _logService.writeInfo('No video selected');
      throw HomeNotSelectedVideoException();
    }

    _logService.writeInfo('Video Selected');
    final path = file.path;
    return path;
  }
}
