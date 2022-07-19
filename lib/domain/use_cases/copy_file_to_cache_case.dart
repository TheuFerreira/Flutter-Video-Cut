import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

    try {
      await _storageService.copyFile(oldPath, cachedFile);
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s,
          reason: 'Error on copy original file to cache Path');
      throw VideoCopyException();
    }

    return cachedFile;
  }
}
