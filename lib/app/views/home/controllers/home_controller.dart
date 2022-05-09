import 'package:flutter_video_cut/app/interfaces/istorage_service.dart';
import 'package:flutter_video_cut/app/services/storage_service.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final IStorageService _storageService = StorageService();

  @action
  Future<void> searchVideo() async {
    final file = await _storageService.pickVideo();
    if (file == null) {
      return;
    }
  }
}
