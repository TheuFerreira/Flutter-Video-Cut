import 'package:flutter/services.dart';
import 'package:flutter_video_cut/domain/services/version_service.dart';
import 'package:flutter_video_cut/infra/utils/method_channel_name.dart';
import 'package:new_version_plus/new_version_plus.dart';

class VersionServiceImpl implements VersionService {
  final _version = NewVersionPlus();
  final _methodChannel = const MethodChannel(methodChannelName);

  @override
  Future<bool> hasUpdate() async {
    final status = await _version.getVersionStatus();
    if (status == null) {
      return false;
    }

    final canUpdate = status.canUpdate;
    return canUpdate;
  }

  @override
  void updateApp() async {
    final status = await _version.getVersionStatus();
    _version.launchAppStore(status!.appStoreLink);
  }

  @override
  Future<String> getVersion() async {
    final version = await _methodChannel.invokeMethod<String>('getVersion');
    return version!;
  }
}
