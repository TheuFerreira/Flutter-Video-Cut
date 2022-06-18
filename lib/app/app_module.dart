import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/modules/home/domain/services/gallery_service.dart';
import 'package:flutter_video_cut/app/modules/home/domain/services/video_service.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/get_seconds_case.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/pick_video_case.dart';
import 'package:flutter_video_cut/app/modules/home/infra/services/gallery_service_impl.dart';
import 'package:flutter_video_cut/app/modules/home/infra/services/video_service_impl.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<VideoService>((i) => VideoServiceImpl()),
        Bind.factory<GalleryService>((i) => GalleryServiceImpl()),
        Bind.factory<PickVideoCase>((i) => PickVideoCaseImpl(i())),
        Bind.factory<GetSecondsCase>((i) => GetSecondsCaseImpl(i())),
      ];
}
