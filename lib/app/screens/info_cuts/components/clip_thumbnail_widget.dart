import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';

class ClipThumbnailWidget extends StatefulWidget {
  final int index;
  final CutModel cut;
  final bool isSelected;
  final Function(int)? onTap;
  final Function(TapDownDetails, CutModel)? onLongPress;
  const ClipThumbnailWidget(
    this.index,
    this.cut, {
    Key? key,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<ClipThumbnailWidget> createState() => _ClipThumbnailWidgetState();
}

class _ClipThumbnailWidgetState extends State<ClipThumbnailWidget> {
  late TapDownDetails _details;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.isSelected) {
              return;
            }

            widget.onTap!(widget.index);
          },
          onTapDown: (details) {
            _details = details;
          },
          onLongPress: () {
            widget.onLongPress!(_details, widget.cut);
            if (widget.isSelected) {
              return;
            }

            widget.onTap!(widget.index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 90 * (1 / 1.5),
            width: 160 * (1 / 1.5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20),
              border: Border.all(
                color: widget.isSelected ? Colors.red[700]! : const Color.fromARGB(255, 20, 20, 20),
                width: widget.isSelected ? 4.0 : 3.0,
              ),
            ),
            child: Image.memory(widget.cut.thumbnail),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Clip ${widget.index + 1}',
          style: const TextStyle(
            fontSize: 12.0,
            color: Color.fromARGB(255, 150, 150, 150),
          ),
        ),
      ],
    );
  }
}
