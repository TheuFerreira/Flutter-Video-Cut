import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_video_cut/domain/errors/home_errors.dart';
import 'package:flutter_video_cut/domain/services/video_service.dart';
import 'package:flutter_video_cut/domain/use_cases/get_seconds_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([VideoService])
import 'get_seconds_case_test.mocks.dart';

void main() {
  final mockVideo = MockVideoService();
  final getSecondsCase = GetSecondsCaseImpl(mockVideo);

  test('Get seconds of video', () async {
    when(mockVideo.getSeconds(any)).thenAnswer((_) async => 50);

    final seconds = await getSecondsCase('');
    expect(seconds, isA<int>());
  });

  test('Get seconds of video with 9 seconds', () async {
    when(mockVideo.getSeconds(any)).thenAnswer((_) async => 9);

    try {
      await getSecondsCase('');
    } catch (e) {
      expect(e, isA<HomeInvalidVideoException>());
    }
  });

  test('Get seconds of video with 6 minutes', () async {
    when(mockVideo.getSeconds(any)).thenAnswer((_) async => 360);

    try {
      await getSecondsCase('');
    } catch (e) {
      expect(e, isA<HomeInvalidVideoException>());
    }
  });
}
