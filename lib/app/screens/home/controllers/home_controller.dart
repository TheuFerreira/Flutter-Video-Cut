import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
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

// TODO: Pequenas funções
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

    final _core = VideoCore();

    message = 'Cortando o vídeo em pedacinhos...';
    String originalVideo = video.path;
    final paths = await _core.cutInSubclips(originalVideo);
    if (paths!.isEmpty) {
      statusPage = Status.normal;
      message = '';
      return null;
    }

    message = 'Criando Thumbnails...';
    final thumbnails = await _core.getThumbnails(paths);

    List<CutModel> cuts = [];
    for (int i = 0; i < paths.length; i++) {
      final cut = CutModel(paths[i], thumbnails[i]);
      cuts.add(cut);
    }

    statusPage = Status.normal;
    message = '';

    return cuts;
  }
}
