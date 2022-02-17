import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/player_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  final PlayerController player;
  final Function() onPrevious;
  final Function() onNext;

  const PlayerWidget(
    this.player, {
    Key? key,
    required this.onPrevious,
    required this.onNext,
  }) : super(key: key);

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 240,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 20, 20, 20),
        border: Border.all(
          color: const Color.fromARGB(255, 20, 20, 20),
          width: 4,
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AspectRatio(
            aspectRatio: widget.player.controller!.value.aspectRatio,
            child: GestureDetector(
              onTap: widget.player.updateControllers,
              child: VideoPlayer(widget.player.controller!),
            ),
          ),
          Observer(
            builder: (context) => AnimatedScale(
              duration: const Duration(milliseconds: 100),
              scale: widget.player.showControllers ? 1 : 0,
              child: SizedBox(
                width: 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Observer(
                      builder: (context) {
                        final showPrevious = widget.player.showPrevious;
                        return Opacity(
                          opacity: showPrevious ? 1 : 0,
                          child: GestureDetector(
                            onTap: () {
                              if (!showPrevious) {
                                return;
                              }

                              widget.onPrevious();
                            },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(70, 0, 0, 0),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                FontAwesomeIcons.stepBackward,
                                color: Colors.amber,
                                size: 26,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: widget.player.playPause,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(70, 0, 0, 0),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Observer(
                          builder: (context) => Icon(
                            widget.player.isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                            color: Colors.amber,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    Observer(
                      builder: (context) {
                        final showNext = widget.player.showNext;
                        return Opacity(
                          opacity: showNext ? 1 : 0,
                          child: GestureDetector(
                            onTap: () {
                              if (!showNext) {
                                return;
                              }

                              widget.onNext();
                            },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(70, 0, 0, 0),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                FontAwesomeIcons.stepForward,
                                color: Colors.amber,
                                size: 26,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Observer(
              builder: (context) {
                final max = widget.player.maxSeconds;
                final value = widget.player.currentTime;
                return Slider(
                  value: value,
                  onChanged: widget.player.moveClip,
                  max: max,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
