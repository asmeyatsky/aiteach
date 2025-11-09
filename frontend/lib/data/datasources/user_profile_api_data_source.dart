// frontend/lib/data/datasources/user_profile_api_data_source.dart
import 'package:dio/dio.dart';
import 'package:frontend/data/models/user_profile_model.dart';
import 'package:frontend/data/models/user_proficiency_model.dart';
import 'package:frontend/utils/exceptions.dart';

class UserProfileApiDataSource {
  final Dio _dio;

  UserProfileApiDataSource(this._dio);

  Future<UserProfileModel> getUserProfile(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get user profile: ${e.message}');
      }
    }
  }

  Future<UserProficiencyModel> getUserProficiency(int userId) async {
    try {
      final response = await _dio.get('/users/$userId/proficiency');
      return UserProficiencyModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get user proficiency: ${e.message}');
      }
    }
  }

  Future<UserProficiencyModel> setUserProficiency(int userId, String skill, int level) async {
    try {
      final response = await _dio.post(
        '/users/$userId/proficiency',
        data: {
          'skill': skill,
          'level': level,
        },
      );
      return UserProficiencyModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to set user proficiency: ${e.message}');
      }
    }
  }

  Future<UserProficiencyModel> updateAssessmentScore(int userId, double score) async {
    try {
      final response = await _dio.put(
        '/users/$userId/proficiency/score',
        data: {'assessment_score': score},
      );
      return UserProficiencyModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to update assessment score: ${e.message}');
      }
    }
  }
}
