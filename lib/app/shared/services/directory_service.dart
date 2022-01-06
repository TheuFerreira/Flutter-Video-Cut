import 'package:path_provider/path_provider.dart';

class DirectoryService {
  static Future<String> getTemporaryDirectoryPath() async {
    final response = await getTemporaryDirectory();
    return response.path;
  }
}
