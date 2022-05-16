import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/dialogs/question_dialog.dart';
import 'package:flutter_video_cut/app/interfaces/idialog_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DialogService implements IDialogService {
  @override
  void showMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  @override
  void showMessageError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Future<bool> showQuestionDialog(
    BuildContext context,
    String title,
    String description,
  ) async {
    final delete = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return QuestionDialog(
          icon: FontAwesomeIcons.triangleExclamation,
          title: title,
          description: description,
        );
      },
    );

    return delete == true;
  }
}
