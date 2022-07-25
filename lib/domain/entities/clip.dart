import 'dart:typed_data';

class Clip {
  final int index;
  late String url;
  late Uint8List thumbnail;

  Clip({required this.index, required this.url, required this.thumbnail});

  @override
  String toString() {
    return 'Index: $index';
  }
}
