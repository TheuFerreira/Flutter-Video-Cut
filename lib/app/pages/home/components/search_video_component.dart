import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchVideoComponent extends StatefulWidget {
  final Function()? onPressed;
  const SearchVideoComponent({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<SearchVideoComponent> createState() => _SearchVideoComponentState();
}

class _SearchVideoComponentState extends State<SearchVideoComponent> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const FaIcon(FontAwesomeIcons.video),
      label: const Text(
        'Escolher vídeo',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: widget.onPressed,
    );
  }
}
