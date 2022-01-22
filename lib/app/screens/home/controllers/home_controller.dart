import 'dart:typed_data';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:flutter_video_cut/core/video_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @action
  Future<List<CutModel>?> cutVideo(XFile video, int secondsByClip) async {
    String originalVideo = video.path;
    final _core = VideoCore(originalVideo);
    final paths = await _core.cutInClips(maxSecondsByClip: secondsByClip);
    if (paths == null || paths.isEmpty) {
      return null;
    }

    final thumbnails = await _core.getThumbnails(paths);
    List<CutModel> cuts = _generateListOfCuts(paths, thumbnails);

    return cuts;
  }

  List<CutModel> _generateListOfCuts(
      List<String> paths, List<Uint8List> thumbnails) {
    List<CutModel> cuts = [];
    for (int i = 0; i < paths.length; i++) {
      final cut = CutModel(paths[i], thumbnails[i]);
      cuts.add(cut);
    }
    return cuts;
  }

  @action
  Future disposeCuts(List<CutModel> cuts) async {
    for (CutModel cut in cuts) {
      await FileService().deleteIfExists(cut.path);
    }
    cuts.clear();
  }
}
