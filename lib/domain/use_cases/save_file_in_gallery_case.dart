import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';

abstract class SaveFileInGalleryCase {
  Future<void> call(String filePath);
}

class SaveFileInGalleryCaseImpl implements SaveFileInGalleryCase {
  final StorageService _storageService;
  final LogService _logService;

  SaveFileInGalleryCaseImpl(
    this._storageService,
    this._logService,
  );

  @override
  Future<void> call(String filePath) async {
    _logService.writeInfo('Saving file in gallery');
    await _storageService.saveInGallery(filePath);
  }
}
