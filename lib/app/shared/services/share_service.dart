import 'package:share_plus/share_plus.dart';

class ShareService {
  Future shareFiles(List<String> paths) async {
    await Share.shareFiles(paths);
  }
}
