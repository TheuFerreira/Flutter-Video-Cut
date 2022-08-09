import 'package:flutter/material.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ModalSheetComponent extends StatelessWidget {
  final Clip clip;
  final String title;
  final Function() onShareTap;
  final Function() onDeleteTap;
  final Function() onSaveTap;
  const ModalSheetComponent({
    Key? key,
    required this.clip,
    required this.title,
    required this.onShareTap,
    required this.onDeleteTap,
    required this.onSaveTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        ListTile(
          title: const Text('Compartilhar'),
          leading: const Icon(Icons.share),
          onTap: () {
            Navigator.pop(context);
            onShareTap();
          },
        ),
        ListTile(
          title: const Text('Excluir Clip selecionado'),
          leading: const Icon(FontAwesomeIcons.trashCan),
          onTap: () {
            Navigator.pop(context);
            onDeleteTap();
          },
        ),
        ListTile(
          title: const Text('Salvar na Galeria'),
          leading: const Icon(Icons.download),
          onTap: () {
            Navigator.pop(context);
            onSaveTap();
          },
        ),
      ],
    );
  }
}
