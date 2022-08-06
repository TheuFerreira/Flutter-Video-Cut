import 'package:flutter_video_cut/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';

abstract class ReceiveSharedFileCase {
  Future<String> call();
}

class ReceiveSharedFileCaseImpl implements ReceiveSharedFileCase {
  final StorageService _storageService;

  ReceiveSharedFileCaseImpl(this._storageService);

  @override
  Future<String> call() async {
    final path = await _storageService.getSharedFile();
    if (path == null) {
      throw HomeNoVideoSharedException();
    }

    return path;
  }
}
