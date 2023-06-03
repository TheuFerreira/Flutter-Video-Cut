import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app_module.dart';
import 'package:flutter_video_cut/domain/use_cases/delete_file_from_storage_case.dart';
import 'package:flutter_video_cut/domain/use_cases/get_files_in_cache_case.dart';
import 'package:flutter_video_cut/infra/services/log_service_impl.dart';
import 'package:flutter_video_cut/infra/services/path_service_impl.dart';
import 'package:flutter_video_cut/infra/services/storage_service_impl.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_widget.dart';

void onStart(ServiceInstance service) async {
  final pathService = PathServiceImpl();

  final getFilesInCacheCase = GetFilesInCacheCaseImpl(pathService);
  final paths = await getFilesInCacheCase();

  for (final path in paths) {
    final extension = pathService.getExtensionFileName(path);

    if (!extension.contains('mp4')) continue;

    final deleteFileFromStorageCase =
        DeleteFileFromStorageCaseImpl(StorageServiceImpl(), LogServiceImpl());
    deleteFileFromStorageCase(path);
  }

  service.stopSelf();
}

bool onIosBackground(ServiceInstance service) => true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration:
        IosConfiguration(onForeground: onStart, onBackground: onIosBackground),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
      autoStart: true,
      initialNotificationTitle: 'Limpeza',
      initialNotificationContent: 'Limpando resíduos...',
    ),
  );

  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
