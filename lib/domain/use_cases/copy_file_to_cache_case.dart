import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';

abstract class CopyFileToCacheCase {
  Future<String> call(String oldPath);
}

class CopyFileToCacheCaseImpl implements CopyFileToCacheCase {
  final StorageService _storageService;
  final PathService _pathService;

  CopyFileToCacheCaseImpl(this._storageService, this._pathService);

  @override
  Future<String> call(String oldPath) async {
    final cachePath = await _pathService.getCachePath();

    final values = oldPath.split('.');
    final extension = values[values.length - 1];
    final cachedFile = '$cachePath/cachedFile.$extension';

    bool isCopied = await _storageService.copyFile(oldPath, cachedFile);
    if (!isCopied) {
      throw VideoCopyException();
    }

    return cachedFile;
  }
}
