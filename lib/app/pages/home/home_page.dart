import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/pages/home/components/search_video_component.dart';
import 'package:flutter_video_cut/app/pages/home/home_controller.dart';
import 'package:flutter_video_cut/app/views/components/logo_component.dart';
import 'package:flutter_video_cut/app/views/about/about_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const LogoComponent()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/cut.png', height: 80),
                const SizedBox(height: 16),
                Observer(
                  builder: (builder) {
                    final isSearching = homeController.isSearching;
                    if (isSearching) {
                      return const CircularProgressIndicator();
                    }

                    return SearchVideoComponent(
                      onPressed: () => homeController.searchVideo(builder),
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 30),
                ),
                icon: const FaIcon(FontAwesomeIcons.info),
                label: const Text(
                  'Sobre',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => const AboutPage(),
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
