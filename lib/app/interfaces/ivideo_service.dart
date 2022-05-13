abstract class IVideoService {
  Future<List<String>?> cutVideo(
      {required String url, required String destiny, int seconds = 20});
}
