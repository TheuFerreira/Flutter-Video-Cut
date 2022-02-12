import 'package:path_provider/path_provider.dart';

abstract class IDirectoryService {
  Future<String> getTemporaryPath();
}

class DirectoryService implements IDirectoryService {
  @override
  Future<String> getTemporaryPath() async {
    final response = await getTemporaryDirectory();
    return response.path;
  }
}
