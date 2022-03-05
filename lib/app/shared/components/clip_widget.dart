import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';

class ClipWidget extends StatelessWidget {
  final int index;
  final CutModel cut;
  final bool isSelected;
  final Function(CutModel)? onTap;
  const ClipWidget(
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
        Expanded(
          child: GestureDetector(
            onTap: () => onTap!(cut),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 20,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 20, 20, 20),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: isSelected ? Colors.red[700]! : const Color.fromARGB(255, 20, 20, 20),
                  width: isSelected ? 3.0 : 2.0,
                ),
              ),
              child: Image.memory(cut.thumbnail),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 16,
          child: Text(
            'Clip ${index + 1}',
            style: const TextStyle(
              fontSize: 12.0,
              color: Color.fromARGB(255, 150, 150, 150),
            ),
          ),
        ),
      ],
    );
  }
}
