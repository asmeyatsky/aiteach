import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/utils/dio_interceptor.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/models/user.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000')); // Replace with your backend URL
  static const String _tokenKey = 'jwt_token';

  AuthService() {
    _dio.interceptors.add(ErrorInterceptor(this));
  }

  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: {'username': username, 'password': password},
      );
      final token = response.data['access_token'];
      if (token != null) {
        await _saveToken(token);
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

  Future<bool> register(String username, String email, String password) async {
    try {
      await _dio.post(
        '/users/register',
        data: {'username': username, 'email': email, 'password': password},
      );
      return true;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Registration failed: ${e.message}');
      }
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get user info: ${e.message}');
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
