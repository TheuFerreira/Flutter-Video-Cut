import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        FaIcon(
          FontAwesomeIcons.cut,
          color: Colors.amber,
        ),
        SizedBox(width: 8.0),
        Text(
          'Video Cut',
          style: TextStyle(
            fontSize: 22,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}
