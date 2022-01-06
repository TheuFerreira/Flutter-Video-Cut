import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:flutter_video_cut/app/shared/services/storage_service.dart';
import 'package:flutter_video_cut/core/video_core.dart';
import 'package:mobx/mobx.dart';
import 'package:share_plus/share_plus.dart';

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
  Future cutVideo() async {
    statusPage = Status.loading;
    message = 'Esperando escolher o vídeo...';

    final video = await StorageService().getVideo();
    if (video == null) {
      statusPage = Status.normal;
      message = '';
      return;
    }

    message = 'Cortando o vídeo em pedacinhos...';
    String originalVideo = video.path;
    final paths = await VideoCore().cutInSubclips(originalVideo);
    if (paths!.isEmpty) {
      statusPage = Status.normal;
      message = '';
      return;
    }

    message = 'Aguardando compartilhar...';
    await Share.shareFiles(paths);

    message = 'Removendo pedacinhos...';
    for (String path in paths) {
      await FileService().deleteIfExists(path);
    }

    statusPage = Status.normal;
    message = '';
  }
}
