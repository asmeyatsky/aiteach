import 'package:dio/dio.dart';
import 'package:frontend/models/user_proficiency.dart';
import 'package:frontend/utils/dio_interceptor.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/services/auth_service.dart';

class ProficiencyService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));
  final AuthService _authService;

  ProficiencyService(this._authService) {
    _dio.interceptors.add(ErrorInterceptor(_authService));
  }

  Future<UserProficiency?> getUserProficiency(int userId) async {
    try {
      final response = await _dio.get('/users/$userId/proficiency');
      return UserProficiency.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error as ApiException;
    }
  }

  Future<UserProficiency> setUserProficiency(int userId, ProficiencyLevel level) async {
    try {
      final response = await _dio.post(
        '/users/$userId/proficiency',
        data: {
          'selected_level': level.name,
          'assessment_score': 0.0, // Will be updated after assessment
        },
      );
      return UserProficiency.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error as ApiException;
    }
  }

  Future<UserProficiency> updateAssessmentScore(int userId, double score) async {
    try {
      final response = await _dio.put(
        '/users/$userId/proficiency/score',
        data: {'assessment_score': score},
      );
      return UserProficiency.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error as ApiException;
    }
  }
}