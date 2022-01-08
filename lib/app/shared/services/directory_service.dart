import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryService {
  static Future<String> getTemporaryDirectoryPath() async {
    final response = await getTemporaryDirectory();
    return response.path;
  }

  static Future<Directory> getAppDirectory() async {
    String path = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DCIM) +
        '/Video Cut';

    return await createDirectoryIfNotExists(path);
  }

  static Future<Directory> createDirectoryIfNotExists(
    String path, {
    bool recursive = false,
  }) async {
    Directory dir = Directory(path);
    final exists = await dir.exists();

    if (exists == false) {
      dir = await dir.create(recursive: recursive);
    }

    return dir;
  }
}
