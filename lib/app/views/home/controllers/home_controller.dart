import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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

    File? file;
    try {
      file = await _storageService.pickVideo();
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Error on Pick Video',
      );
      return;
    } finally {
      isSearching = false;
    }

    if (file == null) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builder) => VideoPage(videoPath: file!.path),
      ),
    );
  }
}
