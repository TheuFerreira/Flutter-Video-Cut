import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/pick_video_case.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<PickVideoCase>((i) => PickVideoCaseImpl()),
      ];
}
