import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';

abstract class DeleteFileFromStorageCase {
  void call(String url);
}

class DeleteFileFromStorageCaseImpl implements DeleteFileFromStorageCase {
  final StorageService _storageService;
  final LogService _logService;

  DeleteFileFromStorageCaseImpl(
    this._storageService,
    this._logService,
  );

  @override
  void call(String url) {
    _logService.writeInfo('Checking if file exists in Storage');
    final exists = _storageService.checkFileExists(url);
    if (!exists) {
      _logService.writeInfo('File doesn\'t exists');
      return;
    }

    _logService.writeError('Deleting file from Storage Case');
    _storageService.deleteFile(url);
  }
}
