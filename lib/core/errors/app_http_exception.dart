class AppHttpException implements Exception {
  final String message;

  const AppHttpException(this.message);

  @override
  String toString() => message;
}
