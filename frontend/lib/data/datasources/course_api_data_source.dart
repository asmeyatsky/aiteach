// frontend/lib/data/datasources/course_api_data_source.dart
import 'package:dio/dio.dart';
import 'package:frontend/data/models/course_model.dart';
import 'package:frontend/data/models/lesson_model.dart';
import 'package:frontend/utils/exceptions.dart';

class CourseApiDataSource {
  final Dio _dio;

  CourseApiDataSource(this._dio);

  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await _dio.get('/courses/');
      return (response.data as List).map((json) => CourseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get courses: ${e.message}');
      }
    }
  }

  Future<CourseModel> getCourseDetails(int courseId) async {
    try {
      final response = await _dio.get('/courses/$courseId');
      return CourseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get course details: ${e.message}');
      }
    }
  }

  Future<CourseModel> createCourse(String title, String description, String tier, String? thumbnailUrl) async {
    try {
      final response = await _dio.post(
        '/courses/',
        data: {
          'title': title,
          'description': description,
          'tier': tier,
          'thumbnail_url': thumbnailUrl,
        },
      );
      return CourseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to create course: ${e.message}');
      }
    }
  }

  Future<LessonModel> createLesson(int courseId, String title, String contentType, String contentData, int order) async {
    try {
      final response = await _dio.post(
        '/courses/$courseId/lessons/',
        data: {
          'title': title,
          'content_type': contentType,
          'content_data': contentData,
          'order': order,
        },
      );
      return LessonModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to create lesson: ${e.message}');
      }
    }
  }

  Future<List<LessonModel>> getLessonsByCourse(int courseId) async {
    try {
      final response = await _dio.get('/courses/$courseId/lessons/');
      return (response.data as List).map((json) => LessonModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get lessons by course: ${e.message}');
      }
    }
  }
}
