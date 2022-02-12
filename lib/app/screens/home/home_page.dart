import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cut/app/screens/credits/credits_page.dart';
import 'package:flutter_video_cut/app/screens/home/controllers/home_controller.dart';
import 'package:flutter_video_cut/app/screens/home/dialog/text_time_dialog.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/info_cuts_page.dart';
import 'package:flutter_video_cut/app/shared/components/logo_widget.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:flutter_video_cut/app/shared/services/storage_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = HomeController();
  String values = "";

  @override
  void initState() {
    super.initState();

    _getVideoFromShared();
  }

  void _getVideoFromShared() async {
    final result =
        await const MethodChannel("com.example.flutter_video_cut.path")
            .invokeMethod<String>('getSharedData');
    if (result == '' || result == null) {
      return;
    }

    log(result);

    XFile video = XFile(result);
    await _processVideo(video);
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
                onPressed: _searchVideo,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: TextButton.icon(
              onPressed: _showCreditsPage,
              icon: const FaIcon(Icons.privacy_tip),
              label: const Text('Créditos'),
            ),
          ),
        ],
      ),
    );
  }

  void _searchVideo() async {
    final video = await StorageService().getVideo();
    if (video == null) {
      return null;
    }

    await _processVideo(video);
  }

  Future _processVideo(XFile video) async {
    final secondsByClip = await showDialog<int?>(
      context: context,
      builder: (ctx) => const TextTimeDialog(),
    );
    if (secondsByClip == null) {
      return;
    }

    final ds = DialogService(context);
    ds.showLoading(
      'Aguarde um pouco!!!',
      'Estamos cortando seu vídeo em pedacinhos...',
    );

    final cuts = await _controller.cutVideo(video, secondsByClip);
    if (cuts == null || cuts.isEmpty) {
      return;
    }

    ds.closeLoading();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => InfoCutsPage(cuts),
      ),
    );

    await _controller.disposeCuts(cuts);
  }

  void _showCreditsPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreditsPage(),
      ),
    );
  }
}
