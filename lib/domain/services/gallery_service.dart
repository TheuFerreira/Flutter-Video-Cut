import 'dart:io';

abstract class GalleryService {
  Future<File?> pickVideo();
}
