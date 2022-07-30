import 'package:flutter/material.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';

class ClipGridComponent extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  final Clip clip;
  final String title;
  final bool isSelected;
  final Function(Clip) onTap;
  const ClipGridComponent({
    Key? key,
    required this.itemHeight,
    required this.itemWidth,
    required this.clip,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(clip),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: itemHeight - 18,
            width: itemWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 20, 20, 20),
              border: Border.all(
                color: isSelected
                    ? Colors.red[700]!
                    : const Color.fromARGB(255, 20, 20, 20),
                width: isSelected ? 3 : 2,
              ),
            ),
            child: Image.memory(clip.thumbnail!),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 150, 150, 150),
          ),
        ),
      ],
    );
  }
}
