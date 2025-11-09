// frontend/lib/data/datasources/gamification_api_data_source.dart
import 'package:dio/dio.dart';
import 'package:frontend/data/models/badge_model.dart';
import 'package:frontend/data/models/user_badge_model.dart';
import 'package:frontend/utils/exceptions.dart';

class GamificationApiDataSource {
  final Dio _dio;

  GamificationApiDataSource(this._dio);

  Future<List<BadgeModel>> getBadges() async {
    try {
      final response = await _dio.get('/gamification/badges/');
      return (response.data as List).map((json) => BadgeModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get badges: ${e.message}');
      }
    }
  }

  Future<BadgeModel> createBadge(String name, String description, String? iconUrl) async {
    try {
      final response = await _dio.post(
        '/gamification/badges/',
        data: {
          'name': name,
          'description': description,
          'icon_url': iconUrl,
        },
      );
      return BadgeModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to create badge: ${e.message}');
      }
    }
  }

  Future<List<UserBadgeModel>> getUserBadges(int userId) async {
    try {
      final response = await _dio.get('/gamification/users/$userId/badges');
      return (response.data as List).map((json) => UserBadgeModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get user badges: ${e.message}');
      }
    }
  }

  Future<UserBadgeModel> createUserBadge(int userId, int badgeId) async {
    try {
      final response = await _dio.post(
        '/gamification/user_badges/',
        data: {
          'user_id': userId,
          'badge_id': badgeId,
        },
      );
      return UserBadgeModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to create user badge: ${e.message}');
      }
    }
  }
}
