import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/components/player_widget.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/info_cuts_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/options_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/player_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/enums/playback_type.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/enums/player_state.dart';
import 'package:flutter_video_cut/app/shared/components/progress_widget.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            onPressed: () => _controller.shareCuts(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Observer(
              builder: (context) {
                final isInitialized = _player.state == PlayerState.initialized;
                if (!isInitialized) {
                  return const Expanded(
                    child: ProgressWidget('Carregando'),
                  );
                }
                return Expanded(
                  child: PlayerWidget(
                    _player,
                    onPrevious: () => _controller.selectPreviousClip(),
                    onNext: () => _controller.selectNextClip(),
                  ),
                );
              },
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
                      Observer(
                        builder: (context) {
                          final type = _options.playbackType;
                          _controller.playbackType = type;
                          IconData icon = Icons.repeat_one;
                          if (type == PlaybackType.loop) {
                            icon = Icons.loop;
                          } else if (type == PlaybackType.repeate) {
                            icon = Icons.repeat;
                          }
                          return IconButton(
                            onPressed: _options.nextPlaybackType,
                            iconSize: 28.0,
                            icon: Icon(
                              icon,
                              color: Colors.white38,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () => _options.joinClips(context),
                        icon: const Icon(
                          FontAwesomeIcons.objectGroup,
                          color: Colors.white38,
                        ),
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
