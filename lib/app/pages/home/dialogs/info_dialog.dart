import 'package:flutter/material.dart';

class InfoDialog {
  late BuildContext context;

  void show(
    BuildContext context, {
    String text = 'Estamos cortando seu vídeo em pedacinhos...',
  }) {
    this.context = context;

    showDialog(
      context: this.context,
      builder: (_) => _InfoDialog(
        text: text,
      ),
    );
  }

  void close() {
    Navigator.of(context).pop();
  }
}

class _InfoDialog extends StatelessWidget {
  final String text;
  const _InfoDialog({Key? key, required this.text}) : super(key: key);

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
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
