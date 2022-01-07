import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/info_cuts_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/player_controller.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/enums/player_state.dart';
import 'package:flutter_video_cut/app/shared/controllers/progress_widget.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/dialog_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late InfoCutsController controller;
  late PlayerController player;
  final _scrollClips = ScrollController();

  @override
  void initState() {
    super.initState();

    controller = InfoCutsController(widget.cuts);
    player = PlayerController();

    _loadClip();
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
            onPressed: _shareCuts,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Observer(
              builder: (context) => Expanded(
                child: player.state == PlayerState.initialized
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
                              aspectRatio: player.controller!.value.aspectRatio,
                              child: GestureDetector(
                                onTap: _onTapVideo,
                                child: VideoPlayer(player.controller!),
                              ),
                            ),
                            Observer(
                              builder: (context) => GestureDetector(
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 100),
                                  scale: player.showControllers ? 1 : 0,
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(70, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Observer(
                                      builder: (context) => Icon(
                                        player.isPlaying
                                            ? FontAwesomeIcons.pause
                                            : FontAwesomeIcons.play,
                                        color: Colors.amber,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: player.playPause,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: VideoProgressIndicator(
                                player.controller!,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: Colors.amber,
                                ),
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
                      builder: (context) {
                        bool isDeleting = controller.deleted;
                        if (isDeleting) {
                          return Container();
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          controller: _scrollClips,
                          itemCount: controller.cuts.length,
                          itemBuilder: (builder, i) => Observer(
                            builder: (ctx) => ClipThumbnailWidget(
                              i,
                              controller.cuts[i],
                              isSelected: controller.selected == i,
                              onTap: _onTapClipThumbnail,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _delClip,
                        icon: const FaIcon(
                          FontAwesomeIcons.trashAlt,
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

  _shareCuts() async {
    await controller.shareCuts();
  }

  _onTapVideo() {
    player.updateControllers();
  }

  _onTapClipThumbnail(int index) async {
    controller.selectClip(index);

    await player.dispose();
    await _loadClip();
  }

  _loadClip() async {
    final clipPath = controller.pathSelectedCut;
    await player.loadClip(clipPath);
  }

  _delClip() async {
    final clipSelected = controller.selected + 1;
    final result = await DialogService.showConfirmationDialog(
      context,
      'Tem certeza de que deseja excluir o Clip $clipSelected? Esta ação não poderá ser desfeita!',
    );

    if (result == false) {
      return;
    }

    final nextIndex = await controller.deleteClip(controller.selected);

    Fluttertoast.showToast(
      msg: 'Clip $clipSelected deletado com sucesso',
      toastLength: Toast.LENGTH_SHORT,
    );

    if (nextIndex == -1) {
      Navigator.pop(context);
    } else {
      await _onTapClipThumbnail(nextIndex);
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
