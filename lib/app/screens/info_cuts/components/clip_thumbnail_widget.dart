import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';

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
