import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/components/logo_component.dart';
import 'package:flutter_video_cut/app/pages/share/share_page.dart';
import 'package:flutter_video_cut/app/pages/video/components/action_button_component.dart';
import 'package:flutter_video_cut/app/pages/video/components/clip_component.dart';
import 'package:flutter_video_cut/app/pages/video/video_controller.dart';
import 'package:flutter_video_cut/app/utils/playback_type.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final List<Clip> clips;
  const VideoPage({
    Key? key,
    required this.clips,
  }) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final _controller = VideoController();
  final _scrollClips = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.load(widget.clips);
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) => SharePage(clips: _controller.clips),
              ),
            ),
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
              Observer(
                builder: (_) {
                  final playbackType = _controller.playbackType;
                  IconData iconData = Icons.repeat_one;
                  if (playbackType == PlaybackType.loop) {
                    iconData = Icons.loop;
                  } else if (playbackType == PlaybackType.repeat) {
                    iconData = Icons.repeat;
                  }
                  return IconButton(
                    onPressed: _controller.changePlaybackType,
                    icon: Icon(iconData),
                  );
                },
              ),
              Observer(
                builder: (_) {
                  final playbackSpeed = _controller.playbackSpeed;
                  return TextButton(
                    onPressed: _controller.changePlaybackSpeed,
                    child: Text(
                      playbackSpeed.text,
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () => _controller.saveFileInGallery(context),
                icon: const Icon(Icons.download),
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
