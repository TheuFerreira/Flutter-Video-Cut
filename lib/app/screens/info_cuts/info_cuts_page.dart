import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/controllers/info_cuts_controller.dart';
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
  late InfoCutsController controller;

  @override
  void initState() {
    super.initState();

    controller = InfoCutsController(widget.cuts);
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
            Flexible(
              child: Container(),
            ),
            SizedBox(
              height: 150,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.cuts.length,
                      itemBuilder: (builder, i) {
                        return Observer(
                          builder: (context) => ClipThumbnailWidget(
                            i,
                            widget.cuts[i],
                            isSelected: controller.selected == i,
                            onTap: controller.selectClip,
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: const [],
                  ),
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

    Navigator.pop(context);
  }
}
