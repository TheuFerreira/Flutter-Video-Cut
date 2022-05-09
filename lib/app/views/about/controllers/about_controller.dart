import 'package:flutter_video_cut/app/interfaces/iurl_launcher.dart';
import 'package:flutter_video_cut/app/services/url_launcher.dart';
import 'package:mobx/mobx.dart';

part 'about_controller.g.dart';

class AboutController = _AboutControllerBase with _$AboutController;

abstract class _AboutControllerBase with Store {
  final IUrlLauncher _urlLauncher = UrlLauncher();

  @action
  Future<void> openUrl(String url) async {
    final success = await _urlLauncher.openUrl(url);
    // TODO: Message when url not opened
  }
}
