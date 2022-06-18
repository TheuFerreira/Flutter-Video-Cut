import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_video_cut/app/modules/home/domain/services/gallery_service.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/pick_video_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GalleryService])
import 'pick_video_case_test.mocks.dart';

void main() {
  final mockGallery = MockGalleryService();
  final _pickVideoCase = PickVideoCaseImpl(mockGallery);

  test('Get video successfull', () async {
    when(mockGallery.pickVideo()).thenAnswer((_) async => File(''));

    final path = await _pickVideoCase();
    expect(path, isA<String>());
  });

  test('Don\'t selected video', () async {
    when(mockGallery.pickVideo()).thenAnswer((_) async => null);

    final path = await _pickVideoCase();
    expect(path, isA<void>());
  });
}
