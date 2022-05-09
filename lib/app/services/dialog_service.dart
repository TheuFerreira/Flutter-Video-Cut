import 'package:flutter_video_cut/app/interfaces/idialog_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogService implements IDialogService {
  @override
  void showMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }
}
