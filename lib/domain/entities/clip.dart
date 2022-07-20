import 'dart:typed_data';

class Clip {
  final int index;
  final String url;
  final Uint8List thumbnail;

  const Clip({required this.index, required this.url, required this.thumbnail});

  @override
  String toString() {
    return 'Index: $index';
  }
}
