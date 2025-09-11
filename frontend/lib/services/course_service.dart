import 'package:dio/dio.dart';
import 'package:frontend/models/course.dart';
import 'package:frontend/models/lesson.dart';
import 'package:frontend/models/user_progress.dart';
import 'package:frontend/utils/dio_interceptor.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/services/auth_service.dart';

class CourseService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000')); // Replace with your backend URL
  final AuthService _authService;

  CourseService(this._authService) {
    _dio.interceptors.add(ErrorInterceptor(_authService));
  }

  Future<List<Course>> getCourses() async {
    try {
      final response = await _dio.get('/courses/');
      return (response.data as List).map((json) => Course.fromJson(json)).toList();
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }

  Future<List<Lesson>> getLessonsByCourse(int courseId) async {
    try {
      final response = await _dio.get('/courses/$courseId/lessons/');
      return (response.data as List).map((json) => Lesson.fromJson(json)).toList();
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }

  Future<UserProgress?> markLessonComplete(int lessonId, int userId) async {
    try {
      final response = await _dio.post('/courses/lessons/$lessonId/complete');
      return UserProgress.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }

  Future<List<UserProgress>> getUserProgress(int userId) async {
    try {
      final response = await _dio.get('/progress/users/$userId/progress');
      return (response.data as List).map((json) => UserProgress.fromJson(json)).toList();
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }
}