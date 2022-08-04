import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String description;
  const ErrorDialog({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  const Icon(
                    Icons.error,
                    size: 56,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.amber,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Ok',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
