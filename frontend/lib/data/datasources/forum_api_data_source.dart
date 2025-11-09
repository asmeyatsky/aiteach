// frontend/lib/data/datasources/forum_api_data_source.dart
import 'package:dio/dio.dart';
import 'package:frontend/data/models/forum_post_model.dart';
import 'package:frontend/data/models/forum_comment_model.dart';
import 'package:frontend/utils/exceptions.dart';

class ForumApiDataSource {
  final Dio _dio;

  ForumApiDataSource(this._dio);

  Future<List<ForumPostModel>> getPosts() async {
    try {
      final response = await _dio.get('/forum/posts/');
      return (response.data as List).map((json) => ForumPostModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get forum posts: ${e.message}');
      }
    }
  }

  Future<ForumPostModel> getPostDetails(int postId) async {
    try {
      final response = await _dio.get('/forum/posts/$postId');
      return ForumPostModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get forum post details: ${e.message}');
      }
    }
  }

  Future<ForumPostModel> createPost(String title, String body, int userId) async {
    try {
      final response = await _dio.post(
        '/forum/posts/',
        data: {'title': title, 'body': body, 'user_id': userId},
      );
      return ForumPostModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to create forum post: ${e.message}');
      }
    }
  }

  Future<List<ForumCommentModel>> getCommentsByPost(int postId) async {
    try {
      final response = await _dio.get('/forum/posts/$postId/comments/');
      return (response.data as List).map((json) => ForumCommentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to get forum comments: ${e.message}');
      }
    }
  }

  Future<ForumCommentModel> createComment(int postId, String body, int userId) async {
    try {
      final response = await _dio.post(
        '/forum/posts/$postId/comments/',
        data: {'body': body, 'user_id': userId},
      );
      return ForumCommentModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      } else {
        throw ApiException('Failed to create forum comment: ${e.message}');
      }
    }
  }
}
