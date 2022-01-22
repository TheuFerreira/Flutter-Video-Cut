import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/screens/home/controllers/home_controller.dart';
import 'package:flutter_video_cut/app/screens/home/dialog/text_time_dialog.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/info_cuts_page.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:flutter_video_cut/app/shared/services/storage_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = HomeController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
        ),
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
              onPressed: () => showLicensePage(context: context),
              icon: const FaIcon(Icons.privacy_tip),
              label: const Text('Licenças'),
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
}
