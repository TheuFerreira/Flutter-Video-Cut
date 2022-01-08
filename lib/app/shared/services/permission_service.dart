import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> hasExternalStorage() async {
    return await getPermission(Permission.storage);

    /*
    if (await Permission.accessMediaLocation.isDenied) {
      await Permission.accessMediaLocation.request();
    }
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
    */
  }

  Future<bool> getPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    }

    final result = await permission.request();
    return result == PermissionStatus.granted;
  }
}
