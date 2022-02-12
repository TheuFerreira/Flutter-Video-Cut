import 'dart:io';

abstract class IFileService {
  Future deleteIfExists(String path);
}

class FileService implements IFileService {
  @override
  Future deleteIfExists(String path) async {
    final file = File(path);

    final exist = await file.exists();
    if (exist == false) return;

    await file.delete();
  }
}
