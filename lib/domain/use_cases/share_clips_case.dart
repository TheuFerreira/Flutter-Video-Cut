import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';

abstract class ShareClipsCase {
  Future<void> call(List<Clip> clips);
}

class ShareClipsCaseImpl implements ShareClipsCase {
  final StorageService _storageService;

  ShareClipsCaseImpl(this._storageService);

  @override
  Future<void> call(List<Clip> clips) async {
    try {
      final files = clips.map((e) => e.url).toList();

      await _storageService.shareFiles(files);
    } catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on share files');
      rethrow;
    }
  }
}
