import 'package:flutter_video_cut/domain/services/path_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:intl/intl.dart';

abstract class SaveFileInGalleryCase {
  Future<void> call(String filePath);
}

class SaveFileInGalleryCaseImpl implements SaveFileInGalleryCase {
  final StorageService _storageService;
  final PathService _pathService;

  SaveFileInGalleryCaseImpl(
    this._storageService,
    this._pathService,
  );

  @override
  Future<void> call(String filePath) async {
    final cachePath = await _pathService.getCachePath();
    final fileName = Intl().date('yyyy-MM-dd-hh-mm-ss').format(DateTime.now());

    final values = filePath.split('.');
    final extension = values[values.length - 1];
    final destiny = '$cachePath/$fileName.$extension';

    await _storageService.copyFile(filePath, destiny);
    await _storageService.saveInGallery(destiny);

    _storageService.deleteFile(destiny);
  }
}
