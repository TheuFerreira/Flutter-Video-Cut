import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/interfaces/istorage_service.dart';
import 'package:flutter_video_cut/app/services/storage_service.dart';
import 'package:flutter_video_cut/app/views/video/video_page.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  bool isSearching = false;
  final IStorageService _storageService = StorageService();

  @action
  Future<void> searchVideo(BuildContext context) async {
    isSearching = true;

    final file = await _storageService.pickVideo();

    isSearching = false;

    if (file == null) {
      // TODO: Message when fails on search a video
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => VideoPage(videoPath: file.path),
      ),
    );
  }
}
