// frontend/lib/utils/dio_interceptor.dart
import 'package:dio/dio.dart';
import 'package:frontend/utils/exceptions.dart';
import 'dart:async';

typedef GetTokenCallback = Future<String?> Function();
typedef ClearTokenCallback = Future<void> Function();

class ErrorInterceptor extends Interceptor {
  final GetTokenCallback getToken;
  final ClearTokenCallback clearToken;

  ErrorInterceptor({required this.getToken, required this.clearToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add JWT token to all requests if available
    final token = await getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String errorMessage = 'An unexpected error occurred.';
    ApiException exception;

    if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;
      final detail = err.response?.data['detail'] ?? 'Something went wrong.';

      if (statusCode == 401) {
        // If 401, clear token and potentially redirect to login
        await clearToken();
        exception = UnauthorizedException(detail);
      } else {
        switch (statusCode) {
          case 400:
            exception = BadRequestException(detail);
            break;
          case 404:
            exception = NotFoundException(detail);
            break;
          case 500:
            exception = ServerException(detail);
            break;
          default:
            exception = ApiException(detail, statusCode: statusCode);
            break;
        }
      }
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      exception = NetworkException('Connection timed out. Please check your internet connection.');
    } else if (err.type == DioExceptionType.unknown) {
      exception = NetworkException('No internet connection or server is unreachable.');
    } else {
      exception = ApiException(errorMessage);
    }

    // Create a new DioException with the custom exception
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: exception,
    );

    // Pass the new error to the next handler
    handler.next(newError);
  }
}