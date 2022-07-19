import 'dart:io';

import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:share_plus/share_plus.dart';

class StorageServiceImpl implements StorageService {
  @override
  void deleteFile(String url) {
    final file = File(url);
    file.deleteSync();
  }

  @override
  Future<void> copyFile(String url, String destiny) async {
    final file = File(url);
    await file.copy(destiny);
  }

  @override
  Future<void> shareFiles(List<String> files) async {
    await Share.shareFiles(
      files,
      text: 'Video Cut',
      subject: 'Serviço de Compartilhamento',
    );
  }
}
