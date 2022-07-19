import 'dart:typed_data';

import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';

abstract class GetThumbnailsCase {
  Future<List<Clip>> call(List<String> videosCuted);
}

class GetThumbnailsCaseImpl implements GetThumbnailsCase {
  final VideoService _videoService;

  GetThumbnailsCaseImpl(this._videoService);

  @override
  Future<List<Clip>> call(List<String> videosCuted) async {
    List<Clip> clips = [];
    for (String videoCuted in videosCuted) {
      Uint8List? thumbnail = await _videoService.getThumbnail(videoCuted);
      if (thumbnail == null) {
        throw ThumbnailException();
      }

      final clip = Clip(url: videoCuted, thumbnail: thumbnail);
      clips.add(clip);
    }

    return clips;
  }
}
