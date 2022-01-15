import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  final String description;
  const LoadingDialog({
    Key? key,
    this.title = 'Title',
    this.description = 'Description',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
