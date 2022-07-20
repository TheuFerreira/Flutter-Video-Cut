import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/pages/share/components/clip_share_component.dart';
import 'package:flutter_video_cut/app/pages/share/share_controller.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SharePage extends StatefulWidget {
  final List<Clip> clips;
  const SharePage({
    Key? key,
    required this.clips,
  }) : super(key: key);

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final _controller = ShareController();

  @override
  Widget build(BuildContext context) {
    const itemWidth = 160 * (1 / 1.5);
    const itemHeight = 160 * (1 / 1.5);
    final crossAxisCount =
        (MediaQuery.of(context).size.width / itemWidth).floorToDouble().toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Compartilhar',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Observer(
            builder: (context) {
              final isSelected = _controller.hasSelected;
              if (!isSelected) {
                return const SizedBox();
              }
              return IconButton(
                onPressed: _controller.clear,
                icon: const FaIcon(FontAwesomeIcons.linkSlash),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GridView.builder(
              padding: const EdgeInsets.only(bottom: 58),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.clips.length,
              itemBuilder: (ctx, index) => Observer(
                builder: (context) {
                  final clip = widget.clips[index];
                  final isSelected = _controller.selecteds.contains(clip);
                  return ClipShareComponent(
                    clip: clip,
                    itemHeight: itemHeight,
                    itemWidth: itemWidth,
                    title: 'Clip ${index + 1}',
                    isSelected: isSelected,
                    onTap: _controller.tapClip,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 1,
              left: 1,
              right: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Observer(
                        builder: (context) => AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _controller.hasSelected ? 1 : 0,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.share),
                            label: const Text('Compartilhar'),
                            onPressed: _controller.hasSelected
                                ? _controller.share
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
