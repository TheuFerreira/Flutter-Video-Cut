import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/domain/use_cases/delete_file_from_storage_case.dart';
import 'package:intl/intl.dart';

abstract class SaveFileInGalleryCase {
  Future<void> call(String filePath);
}

class SaveFileInGalleryCaseImpl implements SaveFileInGalleryCase {
  final StorageService _storageService;
  final PathService _pathService;
  final DeleteFileFromStorageCase _deleteFileFromStorageCase;
  final LogService _logService;

  SaveFileInGalleryCaseImpl(
    this._storageService,
    this._pathService,
    this._deleteFileFromStorageCase,
    this._logService,
  );

  @override
  Future<void> call(String filePath) async {
    _logService.writeInfo('Getting a Cache Path');
    final cachePath = await _pathService.getCachePath();

    _logService.writeInfo('Converting current date to file name');
    final fileName = Intl().date('yyyy-MM-dd-hh-mm-ss').format(DateTime.now());

    _logService.writeInfo('Getting a Extension of file');
    final extension = _pathService.getExtensionFileName(filePath);

    final destiny = '$cachePath/$fileName.$extension';
    _logService.writeInfo('Final file name, $destiny');

    _logService.writeInfo('Copying file to Cache');
    await _storageService.copyFile(filePath, destiny);

    _logService.writeInfo('Saving file in gallery');
    await _storageService.saveInGallery(destiny);

    _deleteFileFromStorageCase(destiny);
  }
}
