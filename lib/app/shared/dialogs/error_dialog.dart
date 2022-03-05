import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.exclamationTriangle,
                  size: 56,
                  color: Colors.red[700]!,
                ),
                const SizedBox(height: 24.0),
                Text(
                  title,
                  style: const TextStyle(fontSize: 22.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.amber,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: Navigator.of(context).pop,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Continuar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
