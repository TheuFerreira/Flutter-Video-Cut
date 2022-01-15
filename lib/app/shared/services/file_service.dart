import 'dart:io';

class FileService {
  Future deleteIfExists(String path) async {
    final file = File(path);

    final exist = await file.exists();
    if (exist == false) return;

    await file.delete();
  }

  static String getFileName(String path) {
    String directory = File(path).parent.path + '/';
    return path.substring(directory.length);
  }
}
