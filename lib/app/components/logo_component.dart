import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogoComponent extends StatelessWidget {
  const LogoComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.scissors,
          color: Colors.amber,
        ),
        SizedBox(width: 8),
        Text(
          'Video Cut',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}
