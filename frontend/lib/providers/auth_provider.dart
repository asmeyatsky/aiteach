import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/data/datasources/user_api_data_source.dart';
import 'package:frontend/data/repositories/user_repository_impl.dart';
import 'package:frontend/utils/dio_interceptor.dart';
import 'package:frontend/config/environment.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: EnvironmentConfig.apiBaseUrl,
    connectTimeout: EnvironmentConfig.connectTimeout,
    receiveTimeout: EnvironmentConfig.receiveTimeout,
  ));

  // Use a callback approach to avoid circular dependency
  dio.interceptors.add(ErrorInterceptor(
    getToken: () async {
      // Return a dummy token for testing purposes
      return "dummy_token";
    },
    clearToken: () async {
      // Do nothing for testing
    },
  ));
  return dio;
});

final userApiDataSourceProvider = Provider<UserApiDataSource>((ref) {
  return UserApiDataSource(ref.read(dioProvider));
});

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  return UserRepositoryImpl(ref.read(userApiDataSourceProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(userRepositoryProvider));
});
