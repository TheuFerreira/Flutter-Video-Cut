import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cut/app/screens/home/dialog/error_video_dialog.dart';
import 'package:flutter_video_cut/app/screens/home/dialog/loading_dialog.dart';
import 'package:flutter_video_cut/app/screens/home/dialog/text_time_dialog.dart';
import 'package:flutter_video_cut/app/screens/info_cuts/info_cuts_page.dart';
import 'package:flutter_video_cut/app/shared/model/cut_model.dart';
import 'package:flutter_video_cut/app/shared/services/file_service.dart';
import 'package:flutter_video_cut/app/shared/services/storage_service.dart';
import 'package:flutter_video_cut/app/shared/services/thumbnail_service.dart';
import 'package:flutter_video_cut/app/shared/services/video_service.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final IStorageService _storageService = StorageService();
  final IThumbnailService _iThumbnailService = ThumbnailService();
  final IVideoService _videoService = VideoService();

  Future getVideoFromShared(BuildContext context) async {
    MethodChannel methodChannel = const MethodChannel("com.example.flutter_video_cut.path");
    final result = await methodChannel.invokeMethod<String>('getSharedData');
    if (result == '' || result == null) {
      return;
    }

    final exists = await File(result).exists();
    if (!exists) {
      await showDialog(
        context: context,
        builder: (ctx) => const ErrorVideoDialog(),
      );

      return;
    }

    final video = File(result);

    final secondsByClip = await _getSecondsByClip(context);
    if (secondsByClip == null) {
      return;
    }

    final cuts = await _processVideo(context, video, secondsByClip);
    if (cuts == null || cuts.isEmpty) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => InfoCutsPage(cuts),
      ),
    );

    await _disposeCuts(cuts);
  }

  Future searchVideo(BuildContext context) async {
    final video = await _storageService.getVideoFromGallery();
    if (video == null) {
      return;
    }

    final secondsByClip = await _getSecondsByClip(context);
    if (secondsByClip == null) {
      return;
    }

    final cuts = await _processVideo(context, video, secondsByClip);
    if (cuts == null || cuts.isEmpty) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => InfoCutsPage(cuts),
      ),
    );

    await _disposeCuts(cuts);
  }

  Future<int?> _getSecondsByClip(BuildContext context) async {
    final secondsByClip = await showDialog<int?>(
      context: context,
      builder: (ctx) => const TextTimeDialog(),
    );
    return secondsByClip;
  }

  Future<List<CutModel>?> _processVideo(BuildContext context, File video, int secondsByClip) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const LoadingDialog(),
    );

    String originalVideo = video.path;
    final paths = await _videoService.cutInClips(originalVideo, maxSecondsByClip: secondsByClip);
    if (paths == null || paths.isEmpty) {
      return null;
    }

    final List<Uint8List> thumbnails = [];
    for (String path in paths) {
      final thumbnail = await _iThumbnailService.getThumbnail(path);
      thumbnails.add(thumbnail);
    }

    List<CutModel> cuts = [];
    for (int i = 0; i < paths.length; i++) {
      final cut = CutModel(paths[i], thumbnails[i]);
      cuts.add(cut);
    }

    Navigator.of(context).pop();

    return cuts;
  }

  Future _disposeCuts(List<CutModel> cuts) async {
    for (CutModel cut in cuts) {
      await FileService().deleteIfExists(cut.path);
    }
    cuts.clear();
  }
}
