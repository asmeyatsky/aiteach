import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/forum_post.dart';
import 'package:frontend/domain/entities/forum_comment.dart';
import 'package:frontend/data/datasources/forum_api_data_source.dart';
import 'package:frontend/data/repositories/forum_repository_impl.dart';
import 'package:frontend/providers/auth_provider.dart'; // To get Dio instance and AuthService

final forumApiDataSourceProvider = Provider<ForumApiDataSource>((ref) {
  return ForumApiDataSource(ref.read(dioProvider));
});

final forumRepositoryProvider = Provider<ForumRepositoryImpl>((ref) {
  return ForumRepositoryImpl(ref.read(forumApiDataSourceProvider), ref.read(authServiceProvider));
});

final forumPostsProvider = FutureProvider<List<ForumPost>>((ref) async {
  final forumRepository = ref.read(forumRepositoryProvider);
  return forumRepository.getPosts();
});

final forumCommentsProvider = FutureProvider.family<List<ForumComment>, int>((ref, postId) async {
  final forumRepository = ref.read(forumRepositoryProvider);
  return forumRepository.getCommentsByPost(postId);
});