import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_video_cut/app/interfaces/istorage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class StorageService implements IStorageService {
  @override
  Future<File?> pickVideo() async {
    File? file;

    try {
      final _picker = ImagePicker();
      final video = await _picker.pickVideo(source: ImageSource.gallery);
      file = video == null ? null : File(video.path);
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on Pick Video');

      file = null;
    }

    return file;
  }

  @override
  Future<String?> getCachePath() async {
    String? path;
    try {
      final temporaryDirectory = await getTemporaryDirectory();
      path = temporaryDirectory.path;
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on Get Cache Path');

      path = null;
    }

    return path;
  }

  @override
  void deleteFile(String url) {
    final file = File(url);
    file.deleteSync();
  }

  @override
  Future<bool> copyFile(String url, String destiny) async {
    bool isCopied = false;
    try {
      final file = File(url);
      await file.copy(destiny);

      isCopied = true;
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s,
          reason: 'Error on copy original file to cache Path');

      isCopied = false;
    }

    return isCopied;
  }

  @override
  Future<bool> shareFiles(List<String> files) async {
    bool isShared = false;
    try {
      await Share.shareFiles(
        files,
        text: 'Video Cut',
        subject: 'Serviço de Compartilhamento',
      );

      isShared = true;
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'Error on share files');

      isShared = false;
    }
    return isShared;
  }
}
