import 'dart:typed_data';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:flutter_video_cut/app/shared/services/storage_service.dart';
import 'package:flutter_video_cut/core/video_core.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

enum Status {
  normal,
  loading,
}

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  @observable
  Status statusPage = Status.normal;

  @observable
  String message = '';

  @action
  Future<List<CutModel>?> cutVideo() async {
    statusPage = Status.loading;
    message = 'Esperando escolher o vídeo...';

    final video = await StorageService().getVideo();
    if (video == null) {
      statusPage = Status.normal;
      message = '';
      return null;
    }

    message = 'Cortando o vídeo em pedacinhos...';
    String originalVideo = video.path;
    final _core = VideoCore(originalVideo);
    final paths = await _core.cutInClips();
    if (paths!.isEmpty) {
      statusPage = Status.normal;
      message = '';
      return null;
    }

    message = 'Criando Thumbnails...';
    final thumbnails = await _core.getThumbnails(paths);
    List<CutModel> cuts = _generateListOfCuts(paths, thumbnails);

    statusPage = Status.normal;
    message = '';

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
    statusPage = Status.loading;
    message = 'Limpando cache';

    for (CutModel cut in cuts) {
      await FileService().deleteIfExists(cut.path);
    }
    cuts.clear();

    message = '';
    statusPage = Status.normal;
  }
}
