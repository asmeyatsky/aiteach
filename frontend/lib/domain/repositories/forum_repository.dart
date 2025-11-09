// frontend/lib/domain/repositories/forum_repository.dart
import 'package:frontend/domain/entities/forum_post.dart';
import 'package:frontend/domain/entities/forum_comment.dart';

abstract class ForumRepository {
  Future<List<ForumPost>> getPosts();
  Future<ForumPost> getPostDetails(int postId);
  Future<ForumPost> createPost(String title, String body);
  Future<ForumComment> createComment(int postId, String body);
  Future<List<ForumComment>> getCommentsByPost(int postId);
}
