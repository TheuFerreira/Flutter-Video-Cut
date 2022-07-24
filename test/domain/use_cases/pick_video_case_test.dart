import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_video_cut/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/domain/services/gallery_service.dart';
import 'package:flutter_video_cut/domain/services/log_service.dart';
import 'package:flutter_video_cut/domain/use_cases/pick_video_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GalleryService])
import 'pick_video_case_test.mocks.dart';

class MockLogService implements LogService {
  @override
  void writeError(String data) {}

  @override
  void writeInfo(String data) {}
}

void main() {
  final mockGallery = MockGalleryService();
  final mockLog = MockLogService();
  final _pickVideoCase = PickVideoCaseImpl(mockGallery, mockLog);

  test('Get video successfull', () async {
    when(mockGallery.pickVideo()).thenAnswer((_) async => File(''));

    final path = await _pickVideoCase();
    expect(path, isA<String>());
  });

  test('Don\'t selected video', () async {
    when(mockGallery.pickVideo()).thenAnswer((_) async => null);

    try {
      await _pickVideoCase();
    } catch (ex) {
      expect(ex, isA<HomeNotSelectedVideoException>());
    }
  });
}
