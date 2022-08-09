import 'package:flutter/services.dart';
import 'package:flutter_video_cut/domain/services/url_service.dart';
import 'package:flutter_video_cut/infra/utils/method_channel_name.dart';

class UrlServiceImpl implements UrlService {
  final _methodChannel = const MethodChannel(methodChannelName);
  @override
  Future<bool> openUrl(String url) async {
    final result = await _methodChannel.invokeMethod<bool>('openUrl', url);
    return result!;
  }
}
