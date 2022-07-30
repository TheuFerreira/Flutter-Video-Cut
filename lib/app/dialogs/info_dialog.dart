import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_cut/app/utils/fonts.dart';
import 'package:flutter_video_cut/domain/entities/text_info.dart';

class InfoDialog {
  late BuildContext context;

  void show(
    BuildContext context, {
    String? text,
    List<TextInfo>? texts,
  }) {
    this.context = context;

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (_) => _InfoDialog(
        text: text,
        texts: texts,
      ),
    );
  }

  void close() {
    Navigator.of(context).pop();
  }
}

class _InfoDialog extends StatelessWidget {
  final String? text;
  final List<TextInfo>? texts;
  const _InfoDialog({
    Key? key,
    this.text,
    this.texts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            if (text != null)
              Text(
                text!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            if (texts != null)
              SizedBox(
                height: 50,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: defaulFontFamily,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: texts!
                        .map(
                          (e) => RotateAnimatedText(
                            e.text,
                            duration: Duration(milliseconds: e.duration),
                            textAlign: TextAlign.center,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
