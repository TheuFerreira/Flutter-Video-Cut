import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  final String videoPath;
  const VideoPage({
    Key? key,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
