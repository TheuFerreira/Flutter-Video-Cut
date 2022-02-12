import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/screens/credits/controllers/credits_controller.dart';
import 'package:flutter_video_cut/app/shared/components/logo_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  final CreditsController _controller = CreditsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LogoWidget(),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Text(''),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.code),
            title: const Text('Desenvolvedor'),
            subtitle: const Text('Matheus Ferreira'),
            trailing: IconButton(
              color: Colors.white,
              icon: const FaIcon(FontAwesomeIcons.linkedinIn),
              onPressed: () => _controller.open('https://www.linkedin.com/in/theu-ferreira/'),
            ),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.palette),
            title: const Text('Design'),
            subtitle: const Text('Paulo Fernando'),
            trailing: IconButton(
              color: Colors.white,
              icon: const FaIcon(FontAwesomeIcons.linkedinIn),
              onPressed: () => _controller.open('https://www.linkedin.com/in/paulo-fernando-071bb31a9/'),
            ),
          ),
          TextButton.icon(
            onPressed: () => showLicensePage(context: context),
            icon: const FaIcon(Icons.privacy_tip),
            label: const Text('Licenças'),
          )
        ],
      ),
    );
  }
}
