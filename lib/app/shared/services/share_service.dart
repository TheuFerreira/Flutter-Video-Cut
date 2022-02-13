import 'package:share_plus/share_plus.dart';

abstract class IShareService {
  void files(List<String> files);
}

class ShareService implements IShareService {
  @override
  void files(List<String> paths) async {
    await Share.shareFiles(paths);
  }
}
