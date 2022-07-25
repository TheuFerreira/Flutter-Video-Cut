import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_cut/app/components/clip_grid_component.dart';
import 'package:flutter_video_cut/app/pages/join/join_controller.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JoinPage extends StatefulWidget {
  final List<Clip> clips;
  const JoinPage({
    Key? key,
    required this.clips,
  }) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  late JoinController _controller;

  @override
  void initState() {
    _controller = JoinController(widget.clips);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const itemWidth = 160 * (1 / 1.5);
    const itemHeight = 160 * (1 / 1.5);
    final crossAxisCount =
        (MediaQuery.of(context).size.width / itemWidth).floorToDouble().toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Unir Clips',
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
              itemCount: _controller.clips.length,
              itemBuilder: (ctx, index) => Observer(
                builder: (context) {
                  final clip = _controller.clips[index];
                  final isSelected = _controller.selecteds.contains(clip);
                  return ClipGridComponent(
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
                            icon: const Icon(FontAwesomeIcons.objectGroup),
                            label: const Text('Unir'),
                            onPressed: () => _controller.join(context),
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
