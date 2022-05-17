import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/views/about/controllers/about_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _aboutController = AboutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre',
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.code),
            title: const Text('Desenvolvedor'),
            subtitle: const Text('Matheus Ferreira'),
            trailing: const FaIcon(
              FontAwesomeIcons.linkedinIn,
              color: Colors.amber,
            ),
            onTap: () => _aboutController
                .openUrl('https://www.linkedin.com/in/theu-ferreira/'),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.palette),
            title: const Text('Design'),
            subtitle: const Text('Paulo Fernando'),
            trailing: const FaIcon(
              FontAwesomeIcons.linkedinIn,
              color: Colors.amber,
            ),
            onTap: () => _aboutController
                .openUrl('https://www.linkedin.com/in/theu-ferreira/'),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowsRotate),
            title: const Text('Atualização'),
            subtitle: const Text('Procurar por nova versão'),
            trailing: const FaIcon(
              FontAwesomeIcons.googlePlay,
              color: Colors.amber,
            ),
            onTap: () => _aboutController.checkForUpdates(context),
          ),
        ],
      ),
    );
  }
}
