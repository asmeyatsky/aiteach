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

  // Lazily get AuthService instance for interceptor to avoid circular dependency
  // The interceptor needs getToken and clearToken functions.
  // We can pass a function that resolves the AuthService from the ref.
  dio.interceptors.add(ErrorInterceptor(
    getToken: () async => await ref.read(authServiceProvider).getToken(),
    clearToken: () async => await ref.read(authServiceProvider).logout(),
  ));
  return dio;
});

final userApiDataSourceProvider = Provider<UserApiDataSource>((ref) {
  return UserApiDataSource(ref.read(dioProvider));
});

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  return UserRepositoryImpl(ref.read(userApiDataSourceProvider));
});

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.read(userRepositoryProvider)));
