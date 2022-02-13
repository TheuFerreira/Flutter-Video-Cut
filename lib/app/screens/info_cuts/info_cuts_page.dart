import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/info_cuts_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/options_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/player_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/enums/player_state.dart';
import 'package:flutter_video_cut/app/shared/components/progress_widget.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

import 'components/clip_thumbnail_widget.dart';

class InfoCutsPage extends StatefulWidget {
  final List<CutModel> cuts;
  const InfoCutsPage(this.cuts, {Key? key}) : super(key: key);

  @override
  _InfoCutsPageState createState() => _InfoCutsPageState();
}

class _InfoCutsPageState extends State<InfoCutsPage> {
  late InfoCutsController _controller;
  final PlayerController _player = PlayerController();
  late OptionsController _options;
  final _scrollClips = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller = InfoCutsController(widget.cuts, _player);
    _options = OptionsController(_controller, _player);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _controller.shareCuts,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Observer(
              builder: (context) => Expanded(
                child: _player.state == PlayerState.initialized
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 20, 20, 20),
                            width: 4,
                          ),
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _player.controller!.value.aspectRatio,
                              child: GestureDetector(
                                onTap: _player.updateControllers,
                                child: VideoPlayer(_player.controller!),
                              ),
                            ),
                            Observer(
                              builder: (context) => GestureDetector(
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 100),
                                  scale: _player.showControllers ? 1 : 0,
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(70, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Observer(
                                      builder: (context) => Icon(
                                        _player.isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                                        color: Colors.amber,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: _player.playPause,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Observer(
                                builder: (context) {
                                  final max = _player.maxSeconds;
                                  final value = _player.currentTime;
                                  return Slider(
                                    value: value,
                                    onChanged: _player.moveClip,
                                    max: max,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const ProgressWidget('Carregando'),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 140,
              child: Column(
                children: [
                  Expanded(
                    child: Observer(
                      builder: (context) => AnimatedList(
                        key: _controller.listKey,
                        controller: _scrollClips,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        initialItemCount: _controller.cuts.length,
                        itemBuilder: (builder, index, animation) => Observer(
                          builder: (context) => ClipThumbnailWidget(
                            index,
                            _controller.cuts[index],
                            isSelected: _controller.selected == index,
                            onTap: _controller.selectClip,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _options.deleteButton(context),
                        icon: const FaIcon(
                          FontAwesomeIcons.trashAlt,
                          color: Colors.white38,
                        ),
                      ),
                      Observer(
                        builder: (context) {
                          final playbackSpeed = _options.playbackSpeed;
                          return TextButton(
                            onPressed: _options.nextPlaybackSpeed,
                            child: Text(
                              playbackSpeed != null ? playbackSpeed.text : '',
                              style: const TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

// TODO: Playback speed
