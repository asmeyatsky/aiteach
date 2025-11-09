// frontend/lib/data/datasources/user_progress_api_data_source.dart
import 'package:dio/dio.dart';
import 'package:frontend/data/models/user_progress_model.dart';
import 'package:frontend/utils/exceptions.dart';

class UserProgressApiDataSource {
  final Dio _dio;

  UserProgressApiDataSource(this._dio);

  Future<UserProgressModel> markLessonComplete(int lessonId, int userId) async {
    try {
      final response = await _dio.post('/courses/lessons/$lessonId/complete');
      return UserProgressModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to mark lesson complete: ${e.message}');
      }
    }
  }

  Future<List<UserProgressModel>> getUserProgress(int userId) async {
    try {
      final response = await _dio.get('/progress/users/$userId/progress');
      return (response.data as List).map((json) => UserProgressModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get user progress: ${e.message}');
      }
    }
  }
}
