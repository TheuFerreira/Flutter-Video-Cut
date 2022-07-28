import 'dart:typed_data';

abstract class VideoService {
  Future<int> getSeconds(String path);
  Future<Uint8List?> getThumbnail(String url);
  Future<List<String>?> cutVideo({
    required String url,
    required String destiny,
    required int secondsOfClip,
    int seconds = 20,
  });
}
