import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/views/components/logo_component.dart';
import 'package:flutter_video_cut/app/views/video/controllers/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String videoPath;
  const VideoPage({
    Key? key,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final VideoController _controller = VideoController();

  @override
  void initState() {
    super.initState();

    _controller.loadFile(widget.videoPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LogoComponent(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Not Implemented Share
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Observer(
                    builder: (builder) {
                      final isLoaded = _controller.isLoaded;
                      if (!isLoaded) {
                        return const CircularProgressIndicator();
                      }

                      return AspectRatio(
                        aspectRatio:
                            _controller.playerController!.value.aspectRatio,
                        child: GestureDetector(
                          child: VideoPlayer(_controller.playerController!),
                          onTap: () => _controller.resumeVideo(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 150)
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.playerController!.dispose();
  }
}
