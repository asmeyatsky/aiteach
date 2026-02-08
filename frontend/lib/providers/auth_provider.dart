import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/data/datasources/user_api_data_source.dart';
import 'package:frontend/data/repositories/user_repository_impl.dart';
import 'package:frontend/utils/dio_interceptor.dart';
import 'package:frontend/config/environment.dart';
import 'package:dio/dio.dart';

const _storage = FlutterSecureStorage();
const _tokenKey = 'jwt_token';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: EnvironmentConfig.apiBaseUrl,
    connectTimeout: EnvironmentConfig.connectTimeout,
    receiveTimeout: EnvironmentConfig.receiveTimeout,
  ));

  dio.interceptors.add(ErrorInterceptor(
    getToken: () async {
      return await _storage.read(key: _tokenKey);
    },
    clearToken: () async {
      await _storage.delete(key: _tokenKey);
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
