import 'package:flutter_video_cut/domain/services/storage_service.dart';

abstract class DeleteFileFromStorageCase {
  void call(String url);
}

class DeleteFileFromStorageCaseImpl implements DeleteFileFromStorageCase {
  final StorageService _storageService;

  DeleteFileFromStorageCaseImpl(this._storageService);

  @override
  void call(String url) {
    _storageService.deleteFile(url);
  }
}
