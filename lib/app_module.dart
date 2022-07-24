import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/services/version_service.dart';
import 'package:flutter_video_cut/domain/use_cases/cache_file_by_datetime_case.dart';
import 'package:flutter_video_cut/domain/use_cases/save_file_in_gallery_case.dart';
import 'package:flutter_video_cut/infra/services/log_service_impl.dart';
import 'package:flutter_video_cut/infra/services/version_service_impl.dart';
import 'package:flutter_video_cut/domain/services/url_service.dart';
import 'package:flutter_video_cut/domain/use_cases/check_app_version_case.dart';
import 'package:flutter_video_cut/domain/use_cases/update_app_case.dart';
import 'package:flutter_video_cut/infra/services/url_service_impl.dart';
import 'package:flutter_video_cut/domain/services/gallery_service.dart';
import 'package:flutter_video_cut/domain/services/path_service.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';
import 'package:flutter_video_cut/domain/use_cases/copy_file_to_cache_case.dart';
import 'package:flutter_video_cut/domain/use_cases/cut_video_case.dart';
import 'package:flutter_video_cut/domain/use_cases/delete_file_from_storage_case.dart';
import 'package:flutter_video_cut/domain/use_cases/get_seconds_case.dart';
import 'package:flutter_video_cut/domain/use_cases/get_thumbnails_case.dart';
import 'package:flutter_video_cut/domain/use_cases/open_url_case.dart';
import 'package:flutter_video_cut/domain/use_cases/pick_video_case.dart';
import 'package:flutter_video_cut/domain/use_cases/share_clips_case.dart';
import 'package:flutter_video_cut/infra/services/gallery_service_impl.dart';
import 'package:flutter_video_cut/infra/services/path_service_impl.dart';
import 'package:flutter_video_cut/infra/services/storage_service_impl.dart';
import 'package:flutter_video_cut/infra/services/video_service_impl.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        // Services
        Bind.factory<VideoService>((i) => VideoServiceImpl()),
        Bind.factory<GalleryService>((i) => GalleryServiceImpl()),
        Bind.factory<PathService>((i) => PathServiceImpl()),
        Bind.factory<StorageService>((i) => StorageServiceImpl()),
        Bind.factory<UrlService>((i) => UrlServiceImpl()),
        Bind.factory<VersionService>((i) => VersionServiceImpl()),
        Bind.factory<LogService>((i) => LogServiceImpl()),
        // Use Cases
        Bind.factory<CacheFileByDateTimeCase>(
            (i) => CacheFileByDateTimeCaseImpl(i(), i())),
        Bind.factory<PickVideoCase>((i) => PickVideoCaseImpl(i(), i())),
        Bind.factory<GetSecondsCase>((i) => GetSecondsCaseImpl(i(), i())),
        Bind.factory<CutVideoCase>((i) => CutVideoCaseImpl(i(), i(), i())),
        Bind.factory<CopyFileToCacheCase>(
            (i) => CopyFileToCacheCaseImpl(i(), i(), i())),
        Bind.factory<DeleteFileFromStorageCase>(
            (i) => DeleteFileFromStorageCaseImpl(i(), i())),
        Bind.factory<ShareClipsCase>((i) => ShareClipsCaseImpl(i(), i())),
        Bind.factory<GetThumbnailsCase>((i) => GetThumbnailsCaseImpl(i(), i())),
        Bind.factory<OpenUrlCase>((i) => OpenUrlCaseImpl(i(), i())),
        Bind.factory<CheckAppVersionCase>(
            (i) => CheckAppVersionCaseImpl(i(), i())),
        Bind.factory<UpdateAppCase>((i) => UpdateAppCaseImpl(i(), i())),
        Bind.factory<SaveFileInGalleryCase>(
            (i) => SaveFileInGalleryCaseImpl(i(), i(), i(), i())),
      ];
}
