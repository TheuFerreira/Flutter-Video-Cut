import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/dialogs/error_dialog.dart';
import 'package:flutter_video_cut/app/shared/dialogs/info_dialog.dart';
import 'package:flutter_video_cut/app/shared/dialogs/question_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DialogService {
  static Future<bool> showConfirmationDialog(BuildContext context, String description) async {
    final result = await showDialog(
      context: context,
      builder: (_) {
        return QuestionDialog(
          icon: FontAwesomeIcons.exclamationTriangle,
          title: 'Confirmação de Exclusão',
          description: description,
          onCancel: () => Navigator.pop(context, false),
          onConfirm: () => Navigator.pop(context, true),
        );
      },
    );

    if (result == null) return false;
    return result as bool;
  }

  static void showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static Future<void> showErrorDialog(BuildContext context, String title, String description) async {
    await showDialog(
      context: context,
      builder: (_) {
        return ErrorDialog(
          title: title,
          description: description,
        );
      },
    );
  }

  static Future<void> showInfoDialog(BuildContext context, String description) async {
    await showDialog(
      context: context,
      builder: (_) {
        return InfoDialog(
          description: description,
        );
      },
    );
  }
}
