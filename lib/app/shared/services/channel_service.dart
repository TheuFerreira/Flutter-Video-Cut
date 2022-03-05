import 'package:flutter/services.dart';

abstract class IChannelService {
  Future<bool> shareFiles(List<String> paths);
  Future<String?> getSharedData();
}

class ChannelService implements IChannelService {
  @override
  Future<bool> shareFiles(List<String> paths) async {
    try {
      MethodChannel methodChannel = const MethodChannel("com.example.flutter_video_cut.path");
      await methodChannel.invokeMethod('shareFiles', paths);

      return true;
    } on Exception {
      return true;
    }
  }

  @override
  Future<String?> getSharedData() async {
    MethodChannel methodChannel = const MethodChannel("com.example.flutter_video_cut.path");
    final result = await methodChannel.invokeMethod<String>('getSharedData');
    if (result == '' || result == null) {
      return null;
    }

    return result;
  }
}
