import 'dart:typed_data';

class Clip {
  final int index;
  late String url;
  late Uint8List thumbnail;

  Clip({required this.index, required this.url, required this.thumbnail});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Clip &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          url == other.url &&
          thumbnail == other.thumbnail;

  @override
  int get hashCode => index.hashCode ^ url.hashCode ^ thumbnail.hashCode;

  @override
  String toString() {
    return 'Index: $index | URL: $url';
  }
}
