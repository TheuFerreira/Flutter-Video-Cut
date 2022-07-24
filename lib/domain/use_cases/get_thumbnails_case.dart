import 'dart:typed_data';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';

abstract class GetThumbnailsCase {
  Future<List<Clip>> call(List<String> videosCuted);
}

class GetThumbnailsCaseImpl implements GetThumbnailsCase {
  final VideoService _videoService;
  final LogService _logService;

  GetThumbnailsCaseImpl(
    this._videoService,
    this._logService,
  );

  @override
  Future<List<Clip>> call(List<String> videosCuted) async {
    List<Clip> clips = [];
    for (String videoCuted in videosCuted) {
      _logService.writeInfo('Getting thumbnail of video, $videoCuted');
      try {
        Uint8List? thumbnail = await _videoService.getThumbnail(videoCuted);
        if (thumbnail == null) {
          _logService.writeError('Error on get a thumbnail of video');
          throw ThumbnailException();
        }

        final index = videosCuted.indexOf(videoCuted);
        final clip = Clip(
          index: index,
          url: videoCuted,
          thumbnail: thumbnail,
        );
        clips.add(clip);
      } on ThumbnailException {
        rethrow;
      } on Exception catch (e, s) {
        _logService.writeError(e.toString());
        await FirebaseCrashlytics.instance
            .recordError(e, s, reason: 'Error on get thubmnail of video');
        throw ThumbnailException();
      }
    }

    return clips;
  }
}
