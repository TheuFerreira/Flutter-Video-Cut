class HomeNotSelectedVideoException implements Exception {}

class HomeInvalidVideoException implements Exception {
  final String message;
  HomeInvalidVideoException(this.message);
}
