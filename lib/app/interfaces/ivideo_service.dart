import 'dart:typed_data';

abstract class IVideoService {
  Future<List<String>?> cutVideo(
      {required String url, required String destiny, int seconds = 20});

  Future<Uint8List> getThumbnail(String url);
}
