import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/modules/video/presenter/components/action_button_component.dart';
import 'package:flutter_video_cut/app/modules/video/presenter/components/clip_component.dart';
import 'package:flutter_video_cut/app/modules/video/presenter/video_controller.dart';
import 'package:flutter_video_cut/app/views/components/logo_component.dart';
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
            child: Center(
              child: Observer(
                builder: (builder) {
                  final isLoaded = _controller.isLoaded;
                  if (!isLoaded) {
                    return const CircularProgressIndicator();
                  }

                  return AspectRatio(
                    aspectRatio:
                        _controller.playerController!.value.aspectRatio,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        VideoPlayer(_controller.playerController!),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Observer(
                            builder: (context) {
                              final currentTime = _controller.currentTime;
                              final totalTime = _controller.totalTime;
                              return Slider(
                                min: 0,
                                value: currentTime,
                                max: totalTime,
                                onChangeStart: _controller.startChangeTrack,
                                onChanged: _controller.changeTrack,
                                onChangeEnd: _controller.endChangeTrack,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Observer(
            builder: (_) {
              final isLoaded = _controller.isLoaded;
              if (!isLoaded) {
                return Container();
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Observer(
                    builder: (context) {
                      final isFirst = _controller.isFirstClip;
                      return ActionButtonComponent(
                        icon: FontAwesomeIcons.backwardStep,
                        onTap: isFirst ? null : _controller.previousClip,
                      );
                    },
                  ),
                  Observer(
                    builder: (context) {
                      final isPlaying = _controller.isPlaying;
                      if (isPlaying) {
                        return ActionButtonComponent(
                          icon: FontAwesomeIcons.pause,
                          size: 40,
                          onTap: _controller.resumeVideo,
                        );
                      }
                      return ActionButtonComponent(
                        icon: FontAwesomeIcons.play,
                        size: 40,
                        onTap: _controller.resumeVideo,
                      );
                    },
                  ),
                  Observer(
                    builder: (context) {
                      final isLast = _controller.isLastClip;
                      return ActionButtonComponent(
                        icon: FontAwesomeIcons.forwardStep,
                        onTap: isLast ? null : _controller.nextClip,
                      );
                    },
                  ),
                ],
              );
            },
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
