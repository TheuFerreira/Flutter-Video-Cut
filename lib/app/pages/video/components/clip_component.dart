import 'package:flutter/material.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart' as entities;

class ClipComponent extends StatefulWidget {
  final entities.Clip clip;
  final String? title;
  final bool isSelected;
  final bool showThumbnail;
  final void Function(entities.Clip)? onTap;
  final void Function(entities.Clip)? onDoubleTap;
  const ClipComponent({
    Key? key,
    required this.clip,
    this.title,
    this.onTap,
    this.onDoubleTap,
    this.isSelected = false,
    this.showThumbnail = true,
  }) : super(key: key);

  @override
  State<ClipComponent> createState() => _ClipComponentState();
}

class _ClipComponentState extends State<ClipComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => widget.onTap == null ? null : widget.onTap!(widget.clip),
          onDoubleTap: () => widget.onDoubleTap == null ? null : widget.onDoubleTap!(widget.clip),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 90 * (1 / 1.5),
            width: 160 * (1 / 1.5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20),
              border: Border.all(
                color: widget.isSelected ? Colors.red[700]! : const Color.fromARGB(255, 20, 20, 20),
                width: widget.isSelected ? 3 : 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.showThumbnail ? Image.memory(
                widget.clip.thumbnail!,
                isAntiAlias: true,
              ) : null,
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 150, 150, 150),
            ),
          ),
      ],
    );
  }
}
