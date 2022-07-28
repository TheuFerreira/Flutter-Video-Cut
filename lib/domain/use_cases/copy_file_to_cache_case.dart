import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';

abstract class CopyFileToCacheCase {
  Future<String> call(String oldPath);
}

class CopyFileToCacheCaseImpl implements CopyFileToCacheCase {
  final StorageService _storageService;
  final PathService _pathService;
  final LogService _logService;

  CopyFileToCacheCaseImpl(
    this._storageService,
    this._pathService,
    this._logService,
  );

  @override
  Future<String> call(String oldPath) async {
    _logService.writeInfo('Getting a Cache Path');
    final cachePath = await _pathService.getCachePath();

    _logService.writeInfo('Getting a Extension of file');
    final extension = _pathService.getExtensionFileName(oldPath);

    final cachedFile = '$cachePath/cachedFile.$extension';
    _logService.writeInfo('Final file name, $cachedFile');

    try {
      _logService.writeInfo('Copying file to Cache');
      await _storageService.copyFile(oldPath, cachedFile);
    } catch (e, s) {
      _logService.writeError(e.toString());
      await FirebaseCrashlytics.instance.recordError(e, s,
          reason: 'Error on copy original file to cache Path');
      throw VideoCopyException();
    }

    return cachedFile;
  }
}
