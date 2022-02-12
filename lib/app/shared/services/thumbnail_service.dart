import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

abstract class IThumbnailService {
  Future<Uint8List> getThumbnail(String path);
}

class ThumbnailService implements IThumbnailService {
  @override
  Future<Uint8List> getThumbnail(String path) async {
    final response = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.PNG,
    );

    return response!;
  }
}
