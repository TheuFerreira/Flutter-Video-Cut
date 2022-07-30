import 'dart:typed_data';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';

abstract class GetThumbnailCase {
  Future<Uint8List> call(String videosCuted);
}

class GetThumbnailCaseImpl implements GetThumbnailCase {
  final VideoService _videoService;
  final LogService _logService;

  GetThumbnailCaseImpl(
    this._videoService,
    this._logService,
  );

  @override
  Future<Uint8List> call(String videoCuted) async {
    try {
      _logService.writeInfo('Getting thumbnail of video, $videoCuted');
      Uint8List? thumbnail = await _videoService.getThumbnail(videoCuted);
      if (thumbnail == null) {
        _logService.writeError('Error on get a thumbnail of video');
        throw ThumbnailException();
      }

      return thumbnail;
    } on ThumbnailException {
      rethrow;
    } on Exception catch (e, s) {
      _logService.writeError(e.toString());
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on get thubmnail of video');
      throw ThumbnailException();
    }
  }
}
