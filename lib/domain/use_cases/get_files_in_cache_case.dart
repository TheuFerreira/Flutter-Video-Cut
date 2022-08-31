import 'dart:io';

import 'package:flutter_video_cut/domain/services/path_service.dart';

abstract class GetFilesInCacheCase {
  Future<List<String>> call();
}

class GetFilesInCacheCaseImpl implements GetFilesInCacheCase {
  final PathService _pathService;

  GetFilesInCacheCaseImpl(this._pathService);

  @override
  Future<List<String>> call() async {
    final cachePath = await _pathService.getCachePath();

    final directory = Directory.fromUri(Uri.file(cachePath));
    final files = directory.listSync(followLinks: true);
    final paths = files.map((e) => e.path).toList();
    return paths;
  }
}
