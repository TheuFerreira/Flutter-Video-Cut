import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/views/components/logo_component.dart';
import 'package:flutter_video_cut/app/views/video/components/action_button_component.dart';
import 'package:flutter_video_cut/app/views/video/components/clip_component.dart';
import 'package:flutter_video_cut/app/views/video/controllers/video_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String videoPath;
  final int secondsOfClip;
  const VideoPage({
    Key? key,
    required this.videoPath,
    required this.secondsOfClip,
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

    _controller.cutVideo(widget.videoPath, widget.secondsOfClip, context);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ActionButtonComponent(
                icon: FontAwesomeIcons.backwardStep,
                onTap: () {},
              ),
              ActionButtonComponent(
                icon: FontAwesomeIcons.pause,
                size: 40,
                onTap: () {},
              ),
              ActionButtonComponent(
                icon: FontAwesomeIcons.forwardStep,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
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
                        itemBuilder: (ctx, index, animation) => Observer(
                          builder: (context) {
                            final isSelected =
                                _controller.selectedClip == index;
                            return ClipComponent(
                              index: index,
                              title: 'Clip ${index + 1}',
                              thumbnail: clips[index].thumbnail,
                              isSelected: isSelected,
                              onTap: (index) => _controller.selectClip(index),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _controller.deleteClip(context),
                icon: const FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: Colors.white38,
                ),
              ),
            ],
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
