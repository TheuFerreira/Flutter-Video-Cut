import 'dart:io';

import 'package:flutter_video_cut/domain/services/path_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';

abstract class ClearFilesInCacheCase {
  Future<void> call();
}

class ClearFilesInCacheCaseImpl implements ClearFilesInCacheCase {
  final PathService _pathService;
  final StorageService _storageService;

  const ClearFilesInCacheCaseImpl(
    this._pathService,
    this._storageService,
  );

  @override
  Future<void> call() async {
    final cachePath = await _pathService.getCachePath();

    final directory = Directory.fromUri(Uri.file(cachePath));
    final files = directory.listSync(followLinks: true);
    final paths = files.map((e) => e.path).toList();

    for (final path in paths) {
      final extension = _pathService.getExtensionFileName(path);

      if (!extension.contains('mp4')) continue;

      final exists = _storageService.checkFileExists(path);
      if (!exists) {
        continue;
      }

      _storageService.deleteFile(path);
    }
  }
}
