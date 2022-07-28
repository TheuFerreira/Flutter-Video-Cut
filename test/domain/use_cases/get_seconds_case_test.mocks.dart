// Mocks generated by Mockito 5.2.0 from annotations
// in flutter_video_cut/test/domain/use_cases/get_seconds_case_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;
import 'dart:typed_data' as _i4;

import 'package:flutter_video_cut/domain/services/video_service.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [VideoService].
///
/// See the documentation for Mockito's code generation for more information.
class MockVideoService extends _i1.Mock implements _i2.VideoService {
  MockVideoService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<int> getSeconds(String? path) =>
      (super.noSuchMethod(Invocation.method(#getSeconds, [path]),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
  @override
  _i3.Future<_i4.Uint8List?> getThumbnail(String? url) =>
      (super.noSuchMethod(Invocation.method(#getThumbnail, [url]),
              returnValue: Future<_i4.Uint8List?>.value())
          as _i3.Future<_i4.Uint8List?>);
  @override
  _i3.Future<List<String>?> cutVideo(
          {String? url,
          String? destiny,
          int? secondsOfClip,
          int? seconds = 20}) =>
      (super.noSuchMethod(
              Invocation.method(#cutVideo, [], {
                #url: url,
                #destiny: destiny,
                #secondsOfClip: secondsOfClip,
                #seconds: seconds
              }),
              returnValue: Future<List<String>?>.value())
          as _i3.Future<List<String>?>);
}
