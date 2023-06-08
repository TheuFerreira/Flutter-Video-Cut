import 'package:flutter/services.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';
import 'package:flutter_video_cut/infra/utils/method_channel_name.dart';

class PathServiceImpl implements PathService {
  final _methodChannel = const MethodChannel(methodChannelName);

  @override
  Future<String> getCachePath() async {
    final path = await _methodChannel.invokeMethod<String>('getCacheDirectory');
    return path!;
  }

  @override
  String getExtensionFileName(String path) {
    final values = path.split('.');
    final extension = values[values.length - 1];
    return extension;
  }
}
