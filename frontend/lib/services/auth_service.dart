import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/utils/dio_interceptor.dart';
import 'package:frontend/utils/exceptions.dart';

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
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      await _dio.post(
        '/users/register',
        data: {'username': username, 'email': email, 'password': password},
      );
      return true;
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
