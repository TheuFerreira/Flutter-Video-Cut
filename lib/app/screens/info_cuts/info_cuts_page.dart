import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'components/clip_thumbnail_widget.dart';

class InfoCutsPage extends StatefulWidget {
  final List<CutModel> cuts;
  const InfoCutsPage(this.cuts, {Key? key}) : super(key: key);

  @override
  _InfoCutsPageState createState() => _InfoCutsPageState();
}

class _InfoCutsPageState extends State<InfoCutsPage> {
  int selectedClip = 0;

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
            onPressed: () async {
              //TODO: Controller com função de pegar os caminhos
              List<String> paths = [];
              for (var element in widget.cuts) {
                paths.add(element.path);
              }

              await Share.shareFiles(paths);

              Navigator.pop(context);
            },
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
                    // TODO: Observer
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.cuts.length,
                      itemBuilder: (builder, i) => ClipThumbnailWidget(
                        i,
                        widget.cuts[i],
                        isSelected: selectedClip == i,
                        onTap: (index) {
                          setState(() {
                            selectedClip = index;
                          });
                        },
                      ),
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
}
