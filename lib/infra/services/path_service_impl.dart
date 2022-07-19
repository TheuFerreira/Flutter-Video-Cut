import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';
import 'package:path_provider/path_provider.dart';

class PathServiceImpl implements PathService {
  @override
  Future<String> getCachePath() async {
    try {
      final temporaryDirectory = await getTemporaryDirectory();
      final path = temporaryDirectory.path;
      return path;
    } on Exception {
      throw VideoCacheException();
    }
  }
}
