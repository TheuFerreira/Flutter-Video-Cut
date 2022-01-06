import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/controllers/home_controller.dart';
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
                      onPressed: _controller.cutVideo,
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
