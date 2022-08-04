import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/components/logo_component.dart';
import 'package:flutter_video_cut/app/pages/about/about_page.dart';
import 'package:flutter_video_cut/app/pages/home/components/search_video_component.dart';
import 'package:flutter_video_cut/app/pages/home/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = HomeController();

  @override
  void initState() {
    homeController.loadBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const LogoComponent()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: 468,
            height: 60,
            child: Observer(
              builder: (_) {
                final banner = homeController.topBanner;
                if (banner == null) {
                  return Container();
                }

                return AdWidget(ad: banner);
              },
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/cut.png', height: 80),
                const SizedBox(height: 16),
                SearchVideoComponent(
                  onPressed: () => homeController.searchVideo(context),
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
