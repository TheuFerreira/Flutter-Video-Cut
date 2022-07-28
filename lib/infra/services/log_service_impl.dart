import 'dart:developer';

import 'package:flutter_video_cut/domain/services/log_service.dart';

class LogServiceImpl implements LogService {
  @override
  void writeError(String data) {
    _writeLog('ERROR', data);
  }

  @override
  void writeInfo(String data) {
    _writeLog('INFO', data);
  }

  void _writeLog(String type, String data) {
    final time = DateTime.now().toString();
    log('[$type] $time -> $data');
  }
}
