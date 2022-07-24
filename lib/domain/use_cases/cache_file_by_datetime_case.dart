import 'package:flutter_video_cut/domain/services/datetime_service.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';

abstract class CacheFileByDateTimeCase {
  Future<String> call(String originalFile);
}

class CacheFileByDateTimeCaseImpl implements CacheFileByDateTimeCase {
  final PathService _pathService;
  final DateTimeService _dateTimeService;
  final LogService _logService;

  CacheFileByDateTimeCaseImpl(
    this._pathService,
    this._dateTimeService,
    this._logService,
  );

  @override
  Future<String> call(String originalFile) async {
    _logService.writeInfo('Getting a Cache Path');
    final cachePath = await _pathService.getCachePath();

    _logService.writeInfo('Converting current date to file name');
    final fileName =
        _dateTimeService.getFormattedDateToFileName(DateTime.now());

    _logService.writeInfo('Getting a Extension of file');
    final extension = _pathService.getExtensionFileName(originalFile);

    final destiny = '$cachePath/VideoCut-$fileName.$extension';
    _logService.writeInfo('Final file name, $destiny');

    return destiny;
  }
}
