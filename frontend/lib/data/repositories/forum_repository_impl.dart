// frontend/lib/data/repositories/forum_repository_impl.dart
import 'package:frontend/data/datasources/forum_api_data_source.dart';
import 'package:frontend/data/mappers/forum_post_mapper.dart';
import 'package:frontend/data/mappers/forum_comment_mapper.dart';
import 'package:frontend/domain/entities/forum_post.dart';
import 'package:frontend/domain/entities/forum_comment.dart';
import 'package:frontend/domain/repositories/forum_repository.dart';
import 'package:frontend/services/auth_service.dart'; // For getting user ID

class ForumRepositoryImpl implements ForumRepository {
  final ForumApiDataSource apiDataSource;
  final AuthService authService; // To get current user's ID for creating posts/comments

  ForumRepositoryImpl(this.apiDataSource, this.authService);

  @override
  Future<List<ForumPost>> getPosts() async {
    final postModels = await apiDataSource.getPosts();
    return postModels.map((model) => ForumPostMapper.fromModel(model)).toList();
  }

  @override
  Future<ForumPost> getPostDetails(int postId) async {
    final postModel = await apiDataSource.getPostDetails(postId);
    return ForumPostMapper.fromModel(postModel);
  }

  @override
  Future<ForumPost> createPost(String title, String body) async {
    final currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception('User not logged in'); // Or a custom authentication exception
    }
    final postModel = await apiDataSource.createPost(title, body, currentUser.id);
    return ForumPostMapper.fromModel(postModel);
  }

  @override
  Future<ForumComment> createComment(int postId, String body) async {
    final currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception('User not logged in'); // Or a custom authentication exception
    }
    final commentModel = await apiDataSource.createComment(postId, body, currentUser.id);
    return ForumCommentMapper.fromModel(commentModel);
  }

  @override
  Future<List<ForumComment>> getCommentsByPost(int postId) async {
    final commentModels = await apiDataSource.getCommentsByPost(postId);
    return commentModels.map((model) => ForumCommentMapper.fromModel(model)).toList();
  }
}
