import 'package:flutter_video_cut/app/interfaces/istorage_service.dart';
import 'package:flutter_video_cut/app/modules/video/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/app/services/storage_service.dart';

abstract class CopyFileToCacheCase {
  Future<String> call(String cachePath, String oldPath);
}

class CopyFileToCacheCaseImpl implements CopyFileToCacheCase {
  final IStorageService _storageService = StorageService();

  @override
  Future<String> call(String cachePath, String oldPath) async {
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
