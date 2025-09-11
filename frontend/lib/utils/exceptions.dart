class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: [Status Code: $statusCode] $message';
    }
    return 'ApiException: $message';
  }
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, statusCode: 404);
}

class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, statusCode: 400);
}

class ServerException extends ApiException {
  ServerException(String message) : super(message, statusCode: 500);
}
