class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() {
    return 'ServerException: $message (StatusCode: $statusCode)';
  }
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = "No Internet Connection"});

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({this.message = "Unauthorized Request"});

  @override
  String toString() {
    return 'UnauthorizedException: $message';
  }
}
