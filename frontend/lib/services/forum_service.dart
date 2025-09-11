import 'package:dio/dio.dart';
import 'package:frontend/models/forum_post.dart';
import 'package:frontend/models/forum_comment.dart';
import 'package:frontend/utils/dio_interceptor.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/services/auth_service.dart';

class ForumService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000')); // Replace with your backend URL
  final AuthService _authService;

  ForumService(this._authService) {
    _dio.interceptors.add(ErrorInterceptor(_authService));
  }

  Future<List<ForumPost>> getPosts() async {
    try {
      final response = await _dio.get('/forum/posts/');
      return (response.data as List).map((json) => ForumPost.fromJson(json)).toList();
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }

  Future<ForumPost?> createPost(String title, String body, int userId) async {
    try {
      final response = await _dio.post(
        '/forum/posts/',
        data: {'title': title, 'body': body, 'user_id': userId},
      );
      return ForumPost.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }

  Future<List<ForumComment>> getComments(int postId) async {
    try {
      final response = await _dio.get('/forum/posts/$postId/comments/');
      return (response.data as List).map((json) => ForumComment.fromJson(json)).toList();
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }

  Future<ForumComment?> createComment(int postId, String body, int userId) async {
    try {
      final response = await _dio.post(
        '/forum/posts/$postId/comments/',
        data: {'body': body, 'user_id': userId},
      );
      return ForumComment.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error as ApiException; // Rethrow the custom exception
    }
  }
}