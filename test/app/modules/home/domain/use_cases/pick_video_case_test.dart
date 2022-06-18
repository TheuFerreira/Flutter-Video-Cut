import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_video_cut/app/modules/home/domain/use_cases/pick_video_case.dart';

void main() {
  final _pickVideoCase = PickVideoCaseImpl();

  test('Get video successfull', () async {
    final path = await _pickVideoCase();
    expect(path, isA<String>());
  });
}
