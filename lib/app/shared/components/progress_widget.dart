import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final String message;
  const ProgressWidget(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 12),
        Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
