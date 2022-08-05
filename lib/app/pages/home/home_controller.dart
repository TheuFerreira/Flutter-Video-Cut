import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_video_cut/app/dialogs/dialog_service.dart';
import 'package:flutter_video_cut/app/dialogs/info_dialog.dart';
import 'package:flutter_video_cut/app/pages/home/dialogs/time_video_dialog.dart';
import 'package:flutter_video_cut/app/pages/video/video_page.dart';
import 'package:flutter_video_cut/app/utils/texts.dart';
import 'package:flutter_video_cut/domain/entities/clip.dart';
import 'package:flutter_video_cut/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/domain/errors/video_errors.dart';
import 'package:flutter_video_cut/domain/services/storage_service.dart';
import 'package:flutter_video_cut/domain/use_cases/copy_file_to_cache_case.dart';
import 'package:flutter_video_cut/domain/use_cases/cut_video_case.dart';
import 'package:flutter_video_cut/domain/use_cases/get_seconds_case.dart';
import 'package:flutter_video_cut/domain/use_cases/get_thumbnail_case.dart';
import 'package:flutter_video_cut/domain/use_cases/load_ad_banner_case.dart';
import 'package:flutter_video_cut/domain/use_cases/pick_video_case.dart';
import 'package:flutter_video_cut/domain/use_cases/receive_shared_file_case.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  BannerAd? topBanner;

  final _storageService = Modular.get<StorageService>();
  final _pickVideoCase = Modular.get<PickVideoCase>();
  final _getSecondsCase = Modular.get<GetSecondsCase>();
  final _cutVideoCase = Modular.get<CutVideoCase>();
  final _copyFileToCacheCase = Modular.get<CopyFileToCacheCase>();
  final _getThumbnailCase = Modular.get<GetThumbnailCase>();
  final _loadAdBannerCase = Modular.get<LoadAdBannerCase>();
  final _receiveSharedFileCase = Modular.get<ReceiveSharedFileCase>();

  final _dialogService = DialogService();

  @action
  void load(BuildContext context) => _load(context);
  _load(BuildContext context) async {
    try {
      final path = await _receiveSharedFileCase();
      await _validateVideo(context, path);
    } on HomeNoVideoSharedException {
      return;
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s, reason: 'Error on Load Shared Video');
      _dialogService.showMessageError('Um problema aconteceu');
    }
  }

  @action
  void searchVideo(BuildContext context) => _searchVideo(context);
  _searchVideo(BuildContext context) async {
    try {
      final path = await _pickVideoCase();
      await _validateVideo(context, path);
    } on HomeNotSelectedVideoException {
      return;
    } on HomeInvalidVideoException catch (e) {
      _dialogService.showMessageError(e.message);
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s, reason: 'Error on Search Video');
      _dialogService.showMessageError('Um problema aconteceu');
    }
  }

  Future<void> _validateVideo(BuildContext context, String path) async {
    try {
      final secondsOfVideo = await _getSecondsCase(path);

      final secondsOfClip = await showDialog<int>(
        context: context,
        builder: (builder) {
          return TimeVideoDialog(
            maxSecondsOfVideo: secondsOfVideo,
          );
        },
      );

      if (secondsOfClip == null) {
        return;
      }

      final clips = await _cutVideo(
        path,
        secondsOfVideo,
        secondsOfClip,
        context,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) => VideoPage(clips: clips),
        ),
      );
    } on HomeNotSelectedVideoException {
      return;
    } on HomeInvalidVideoException catch (e) {
      _dialogService.showMessageError(e.message);
    } on ThumbnailException {
      _dialogService.showMessageError('Houve um problema ao buscar as Thumbnails dos vídeos.');
    } on VideoCacheException catch (e, s) {
      _dialogService.showMessageError('Não foi possível encontrar o Cache do Video Cut.');

      await FirebaseCrashlytics.instance.recordError(e, s, reason: 'Error on Get Cache Path');
    } on VideoCopyException {
      _dialogService.showMessageError('Problema ao copiar o arquivo para o cache do Video Cut.');
    } on VideoCutException {
      _dialogService.showMessageError('Houve um problema ao cortar o vídeo selecionado.');
    } on Exception catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s, reason: 'Error on Search Video');
      _dialogService.showMessageError('Um problema aconteceu');
    }
  }

  Future<List<Clip>> _cutVideo(
    String url,
    int secondsOfVideo,
    int secondsOfClip,
    BuildContext context,
  ) async {
    final infoDialog = InfoDialog();

    try {
      infoDialog.show(
        context,
        texts: cutVideoTexts,
      );

      final _cachedFile = await _copyFileToCacheCase(url);

      List<String> videosCuted = await _cutVideoCase(
        cachedFile: _cachedFile,
        secondsOfVideo: secondsOfVideo,
        secondsOfClip: secondsOfClip,
      );

      List<Clip> tempClips = [];
      for (final videoCuted in videosCuted) {
        final thumbnail = await _getThumbnailCase(videoCuted);
        final clip = Clip(
          index: videosCuted.indexOf(videoCuted),
          thumbnail: thumbnail,
          url: videoCuted,
        );

        tempClips.add(clip);
      }

      if (_cachedFile != '') {
        _storageService.deleteFile(_cachedFile);
      }

      return tempClips;
    } catch (e) {
      rethrow;
    } finally {
      infoDialog.close();
    }
  }

  @action
  void loadBanner() {
    _loadAdBannerCase().then((value) => topBanner = value);
  }
}
