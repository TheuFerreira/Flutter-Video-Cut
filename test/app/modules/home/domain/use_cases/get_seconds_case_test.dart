import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/get_seconds_case.dart';

void main() {
  final getSecondsCase = GetSecondsCaseImpl();

  test('Get seconds of video', () async {
    final seconds = await getSecondsCase('');
    expect(seconds, isA<int>());
  });
}
