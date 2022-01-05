import 'dart:io';

class FileService {
  Future deleteIfExists(String path) async {
    final file = File(path);

    final exist = await file.exists();
    if (exist == false) return;

    await file.delete();
  }
}
