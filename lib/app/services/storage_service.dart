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
  Future<String> getCachePath() async {
    final temporaryDirectory = await getTemporaryDirectory();
    final temporaryPath = temporaryDirectory.path;
    return temporaryPath;
  }

  @override
  void deleteFile(String url) {
    final file = File(url);
    file.deleteSync();
  }

  @override
  File copyFile(String url, String destiny) {
    final file = File(url);
    return file.copySync(destiny);
  }

  @override
  void shareFiles(List<String> files) async {
    await Share.shareFiles(
      files,
      text: 'Video Cut',
      subject: 'Serviço de Compartilhamento',
    );
  }
}
