import 'package:flutter/material.dart';

class InfoDialog {
  late BuildContext context;

  void show(BuildContext context) {
    this.context = context;

    showDialog(
      context: this.context,
      builder: (_) {
        return const _InfoDialog();
      },
    );
  }

  void close() {
    Navigator.of(context).pop();
  }
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Estamos cortando seu vídeo em pedacinhos...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
