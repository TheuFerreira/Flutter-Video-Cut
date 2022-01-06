import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/home/controllers/home_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/info_cuts_page.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Observer(
              builder: (builder) {
                final statusPage = _controller.statusPage;
                final message = _controller.message;

                if (statusPage == Status.loading) {
                  return Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    Image.asset('assets/images/cut.png', height: 80),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.video),
                      label: const Text(
                        'Buscar Vídeo',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        final cuts = await _controller.cutVideo();
                        if (cuts == null || cuts.isEmpty) {
                          return;
                        }

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => InfoCutsPage(cuts),
                          ),
                        );

// TODO: Para o Controller
                        for (CutModel cut in cuts) {
                          await FileService().deleteIfExists(cut.path);
                        }
                        cuts.clear();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
