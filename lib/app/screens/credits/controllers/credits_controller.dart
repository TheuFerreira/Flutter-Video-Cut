import 'package:flutter_video_cut/app/shared/services/url_service.dart';
import 'package:mobx/mobx.dart';

part 'credits_controller.g.dart';

class CreditsController = _CreditsControllerBase with _$CreditsController;

abstract class _CreditsControllerBase with Store {
  final IUrlService urlService = UrlService();

  void open(String url) {
    urlService.open(url);
  }
}
