import 'package:dio/dio.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  final AuthService authService;

  ErrorInterceptor(this.authService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add JWT token to all requests if available
    final token = await authService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    String errorMessage = 'An unexpected error occurred.';
    ApiException exception;

    if (err.type == DioErrorType.badResponse) {
      final statusCode = err.response?.statusCode;
      final detail = err.response?.data['detail'] ?? 'Something went wrong.';

      switch (statusCode) {
        case 400:
          exception = BadRequestException(detail);
          break;
        case 401:
          exception = UnauthorizedException(detail);
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
    } else if (err.type == DioErrorType.connectionTimeout ||
        err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout) {
      exception = NetworkException('Connection timed out. Please check your internet connection.');
    } else if (err.type == DioErrorType.unknown) {
      exception = NetworkException('No internet connection or server is unreachable.');
    } else {
      exception = ApiException(errorMessage);
    }

    // Create a new DioError with the custom exception
    final newError = DioError(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: exception,
    );
    
    // Pass the new error to the next handler
    handler.next(newError);
  }
}
