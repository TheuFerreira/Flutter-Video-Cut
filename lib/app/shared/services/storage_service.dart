import 'package:image_picker/image_picker.dart';

class StorageService {
  Future<XFile?> getVideo() async {
    return await ImagePicker().pickVideo(source: ImageSource.gallery);
  }
}
