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

  Future<List<File>> saveListTo(
    List<String> currents,
    List<String> dests,
  ) async {
    List<File> files = [];
    for (int i = 0; i < currents.length; i++) {
      File file = await saveTo(currents[i], dests[i]);
      files.add(file);
    }

    return files;
  }

  Future<File> saveTo(String current, String dest) async {
    return await File(current).copy(dest);
  }
}
