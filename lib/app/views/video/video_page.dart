import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/views/components/logo_component.dart';
import 'package:flutter_video_cut/app/views/video/components/clip_component.dart';
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
  final _scrollClips = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.cutVideo(widget.videoPath);
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
            onPressed: () => _controller.shareFiles(),
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
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Column(
              children: [
                Expanded(
                  child: Observer(
                    builder: (builder) {
                      final clips = _controller.clips;

                      return AnimatedList(
                        key: _controller.listKey,
                        controller: _scrollClips,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        initialItemCount: clips.length,
                        itemBuilder: (ctx, index, animation) {
                          return Observer(
                            builder: (context) {
                              bool isSelected =
                                  _controller.selectedClip == index;
                              return ClipComponent(
                                index: index,
                                title: 'Clip ${index + 1}',
                                thumbnail: clips[index].thumbnail,
                                isSelected: isSelected,
                                onTap: (index) => _controller.selectClip(index),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }
}
