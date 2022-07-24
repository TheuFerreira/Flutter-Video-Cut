import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/domain/use_cases/cache_file_by_datetime_case.dart';
import 'package:flutter_video_cut/domain/use_cases/delete_file_from_storage_case.dart';

abstract class SaveFileInGalleryCase {
  Future<void> call(String filePath);
}

class SaveFileInGalleryCaseImpl implements SaveFileInGalleryCase {
  final StorageService _storageService;
  final DeleteFileFromStorageCase _deleteFileFromStorageCase;
  final CacheFileByDateTimeCase _cacheFileByDateTimeCase;
  final LogService _logService;

  SaveFileInGalleryCaseImpl(
    this._storageService,
    this._deleteFileFromStorageCase,
    this._cacheFileByDateTimeCase,
    this._logService,
  );

  @override
  Future<void> call(String filePath) async {
    final destiny = await _cacheFileByDateTimeCase(filePath);

    _logService.writeInfo('Copying file to Cache');
    await _storageService.copyFile(filePath, destiny);

    _logService.writeInfo('Saving file in gallery');
    await _storageService.saveInGallery(destiny);

    _deleteFileFromStorageCase(destiny);
  }
}
