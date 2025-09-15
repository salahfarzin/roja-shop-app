class HttpError implements Exception {
  final String message;
  final int code;
  HttpError(this.message, this.code);

  @override
  String toString() => 'HttpError($code): $message';
}
