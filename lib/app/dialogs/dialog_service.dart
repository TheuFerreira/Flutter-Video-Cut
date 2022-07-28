import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/dialogs/question_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DialogService {
  void showMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  void showMessageError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
    );
  }

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
          icon: FontAwesomeIcons.question,
          title: title,
          description: description,
        );
      },
    );

    return delete == true;
  }
}
