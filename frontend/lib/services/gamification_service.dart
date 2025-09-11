import 'package:dio/dio.dart';
import 'package:frontend/models/user_profile.dart';
import 'package:frontend/models/user_badge.dart';
import 'package:frontend/utils/dio_interceptor.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/services/auth_service.dart';

class GamificationService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000')); // Replace with your backend URL
  final AuthService _authService;

  GamificationService(this._authService) {
    _dio.interceptors.add(ErrorInterceptor(_authService));
  }

  Future<UserProfile?> getUserProfile(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return UserProfile.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }

  Future<List<UserBadge>> getUserBadges(int userId) async {
    try {
      final response = await _dio.get('/gamification/users/$userId/badges');
      return (response.data as List).map((json) => UserBadge.fromJson(json)).toList();
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }
}