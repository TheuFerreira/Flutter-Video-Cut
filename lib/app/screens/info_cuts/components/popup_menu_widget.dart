import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/enums/popup_menu_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PopupMenuWidget extends PopupMenuEntry<PopupMenuType?> {
  @override
  final double height = 100;

  const PopupMenuWidget({Key? key}) : super(key: key);

  @override
  bool represents(n) => n == 1 || n == -1;

  @override
  State<PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text(
            'Deletar',
            style: TextStyle(color: Colors.white38),
          ),
          leading: const FaIcon(
            FontAwesomeIcons.trashAlt,
            color: Colors.white38,
          ),
          onTap: () => Navigator.of(context).pop(PopupMenuType.delete),
        ),
        ListTile(
          title: const Text(
            'Salvar',
            style: TextStyle(color: Colors.white38),
          ),
          leading: const Icon(
            Icons.save_alt_rounded,
            color: Colors.white38,
          ),
          onTap: () => Navigator.of(context).pop(PopupMenuType.save),
        ),
        ListTile(
          title: const Text(
            'Compartilhar',
            style: TextStyle(color: Colors.white38),
          ),
          leading: const Icon(
            Icons.share,
            color: Colors.white38,
          ),
          onTap: () => Navigator.of(context).pop(PopupMenuType.share),
        ),
        ListTile(
          title: const Text(
            'Cortar Clip',
            style: TextStyle(color: Colors.white38),
          ),
          leading: const Icon(
            FontAwesomeIcons.cut,
            color: Colors.white38,
          ),
          onTap: () => Navigator.of(context).pop(PopupMenuType.cutClip),
        ),
      ],
    );
  }
}
