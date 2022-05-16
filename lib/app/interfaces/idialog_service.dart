import 'package:flutter/material.dart';

abstract class IDialogService {
  void showMessage(String message);
  void showMessageError(String message);
  Future<bool> showQuestionDialog(
      BuildContext context, String title, String description);
}
