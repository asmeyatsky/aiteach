// frontend/lib/data/datasources/user_api_data_source.dart
import 'package:dio/dio.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/config/environment.dart';

class UserApiDataSource {
  final Dio _dio;

  UserApiDataSource(this._dio);

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: {'username': username, 'password': password},
      );
      final token = response.data['access_token'];
      if (token == null) {
        throw ApiException('Login failed: Token not received');
      }
      return token;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Login failed: ${e.message}');
      }
    }
  }

  Future<UserModel> register(String username, String email, String password) async {
    try {
      final response = await _dio.post(
        '/users/register',
        data: {'username': username, 'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Registration failed: ${e.message}');
      }
    }
  }

  Future<UserModel> getCurrentUser(String token) async {
    try {
      final response = await _dio.get(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get user info: ${e.message}');
      }
    }
  }

  Future<bool> deleteUser(String username, String token) async {
    try {
      await _dio.delete(
        '/users/username/$username',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return true;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to delete user: ${e.message}');
      }
    }
  }

  Future<UserModel> getUserById(int id, String token) async {
    try {
      final response = await _dio.get(
        '/users/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get user by ID: ${e.message}');
      }
    }
  }
}
