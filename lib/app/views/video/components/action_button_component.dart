import 'package:flutter/material.dart';

class ActionButtonComponent extends StatelessWidget {
  final IconData icon;
  final double size;
  final void Function() onTap;
  const ActionButtonComponent({
    Key? key,
    required this.icon,
    this.size = 26,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          icon,
          color: Colors.amber,
          size: size,
        ),
      ),
    );
  }
}
