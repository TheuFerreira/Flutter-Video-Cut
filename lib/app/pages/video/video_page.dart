import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/components/logo_component.dart';
import 'package:flutter_video_cut/app/pages/share/share_page.dart';
import 'package:flutter_video_cut/app/pages/video/components/action_button_component.dart';
import 'package:flutter_video_cut/app/pages/video/components/clip_component.dart';
import 'package:flutter_video_cut/app/pages/video/components/modal_sheet_component.dart';
import 'package:flutter_video_cut/app/pages/video/video_controller.dart';
import 'package:flutter_video_cut/app/utils/playback_type.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
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
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _controller.start(widget.clips);
    _controller.clips.observe(_observeListChanges);
  }

  _observeListChanges(ListChange<Clip> listChange) {
    _onRangeChanges(listChange);
    _onElementChanges(listChange);
  }

  _onRangeChanges(ListChange<Clip> listChange) {
    final rangeChanges = listChange.rangeChanges;
    if (rangeChanges == null) {
      return;
    }

    final range = rangeChanges.first;
    final oldValues = range.oldValues;
    if (oldValues == null || range.newValues != null) {
      return;
    }

    for (final clip in oldValues) {
      final index = oldValues.indexOf(clip);
      _listRemoveItem(0, index, clip);
    }
  }

  _onElementChanges(ListChange<Clip> listChange) {
    final elementChanges = listChange.elementChanges;
    if (elementChanges == null) {
      return;
    }

    for (final element in elementChanges) {
      if (element.type == OperationType.add) {
        _listKey.currentState!.insertItem(element.index);
      } else if (element.type == OperationType.remove) {
        final index = element.index;
        final oldValue = element.oldValue!;
        _listRemoveItem(index, index, oldValue);
      }
    }
  }

  _listRemoveItem(int positionToRemove, int index, Clip clip) {
    _listKey.currentState!.removeItem(
      positionToRemove,
      (context, animation) {
        return SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          axis: Axis.horizontal,
          child: ClipComponent(
            clip: clip,
            title: 'Clip ${index + 1}',
            isSelected: false,
          ),
        );
      },
    );
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
                  AnimateIcons(
                    controller: _controller.animateIconController,
                    startIcon: FontAwesomeIcons.play,
                    endIcon: FontAwesomeIcons.pause,
                    size: 40,
                    startIconColor: Colors.amber,
                    endIconColor: Colors.amber,
                    duration: const Duration(milliseconds: 200),
                    onStartIconPress: () {
                      _controller.resumeVideo();
                      return false;
                    },
                    onEndIconPress: () {
                      _controller.resumeVideo();
                      return false;
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
                  child: AnimatedList(
                    key: _listKey,
                    controller: _scrollClips,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    initialItemCount: widget.clips.length,
                    itemBuilder: (ctx, index, animation) {
                      return Observer(
                        builder: (_) {
                          final clip = _controller.clips[index];
                          final selectedClip = _controller.selectedClip;
                          final isSelected = selectedClip == index;
                          return SizeTransition(
                            sizeFactor: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            ),
                            axis: Axis.horizontal,
                            child: ClipComponent(
                              clip: clip,
                              title: 'Clip ${clip.index + 1}',
                              isSelected: isSelected,
                              onTap: _controller.selectClip,
                              onDoubleTap: (Clip clip) {
                                _controller.selectClip(clip);

                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (builder) {
                                    return ModalSheetComponent(
                                      clip: clip,
                                      title: 'Clip ${clip.index + 1}',
                                      onShareTap: () =>
                                          _controller.shareClip(clip),
                                      onDeleteTap: () => _controller
                                          .deleteSelectedClip(context, clip),
                                      onSaveTap: () =>
                                          _controller.saveSelectedFileInGallery(
                                              context, clip),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DragTarget<Clip>(
                onAcceptWithDetails: (clip) =>
                    _controller.deleteSelectedClip(context, clip.data),
                builder: (_, __, ___) => IconButton(
                  onPressed: () => _controller.deleteClip(context),
                  icon: const FaIcon(
                    FontAwesomeIcons.trashCan,
                    color: Colors.white38,
                  ),
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
              DragTarget<Clip>(
                onAcceptWithDetails: (clip) =>
                    _controller.saveSelectedFileInGallery(context, clip.data),
                builder: (_, __, ___) => IconButton(
                  onPressed: () => _controller.saveFileInGallery(context),
                  icon: const Icon(Icons.download),
                ),
              ),
              IconButton(
                onPressed: () => _controller.joinClips(context),
                icon: const Icon(
                  FontAwesomeIcons.objectGroup,
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
