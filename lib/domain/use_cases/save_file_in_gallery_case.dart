import 'package:flutter_video_cut/domain/services/storage_service.dart';

abstract class SaveFileInGalleryCase {
  Future<void> call(String filePath);
}

class SaveFileInGalleryCaseImpl implements SaveFileInGalleryCase {
  final StorageService _storageService;

  SaveFileInGalleryCaseImpl(this._storageService);

  @override
  Future<void> call(String filePath) async {
    await _storageService.saveInGallery(filePath);
  }
}
