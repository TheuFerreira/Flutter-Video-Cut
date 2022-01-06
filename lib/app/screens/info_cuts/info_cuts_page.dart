import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

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

// TODO: Converter para arquivo
class ClipThumbnailWidget extends StatelessWidget {
  final int index;
  final CutModel cut;
  final bool isSelected;
  final Function(int)? onTap;
  const ClipThumbnailWidget(
    this.index,
    this.cut, {
    Key? key,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap!(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 90 * (1 / 1.5),
            width: 160 * (1 / 1.5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20),
              border: Border.all(
                color: isSelected
                    ? Colors.red[700]!
                    : const Color.fromARGB(255, 20, 20, 20),
                width: isSelected ? 4.0 : 3.0,
              ),
            ),
            child: Image.memory(cut.thumbnail),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Clip ${index + 1}',
          style: const TextStyle(
            fontSize: 12.0,
            color: Color.fromARGB(255, 150, 150, 150),
          ),
        ),
      ],
    );
  }
}
