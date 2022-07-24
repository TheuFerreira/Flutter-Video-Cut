import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';

abstract class ShareClipsCase {
  Future<void> call(List<Clip> clips);
}

class ShareClipsCaseImpl implements ShareClipsCase {
  final StorageService _storageService;
  final LogService _logService;

  ShareClipsCaseImpl(
    this._storageService,
    this._logService,
  );

  @override
  Future<void> call(List<Clip> clips) async {
    try {
      _logService.writeInfo('Getting a URL of videos');
      final files = clips.map((e) => e.url).toList();

      _logService.writeInfo('Sharing a files, $files');
      await _storageService.shareFiles(files);
    } catch (e, s) {
      _logService.writeError(e.toString());

      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on share files');
      rethrow;
    }
  }
}
