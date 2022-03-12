import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/screens/credits/credits_page.dart';
import 'package:flutter_video_cut/app/screens/home/controllers/home_controller.dart';
import 'package:flutter_video_cut/app/shared/components/logo_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();

    _controller = HomeController();
    _controller.getVideoFromShared(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LogoWidget(),
      ),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/cut.png', height: 80),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.video),
                label: const Text(
                  'Buscar Vídeo',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () => _controller.searchVideo(context),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const CreditsPage()),
              ),
              icon: const FaIcon(FontAwesomeIcons.info),
              label: const Text(
                'Sobre',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
