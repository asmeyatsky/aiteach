import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/forum_service.dart';
import 'package:frontend/models/forum_post.dart';
import 'package:frontend/models/forum_comment.dart';
import 'package:frontend/providers/auth_provider.dart';

final forumServiceProvider = Provider<ForumService>((ref) {
  final authService = ref.read(authServiceProvider);
  return ForumService(authService);
});

final forumPostsProvider = FutureProvider<List<ForumPost>>((ref) async {
  final forumService = ref.read(forumServiceProvider);
  return forumService.getPosts();
});

final forumCommentsProvider = FutureProvider.family<List<ForumComment>, int>((ref, postId) async {
  final forumService = ref.read(forumServiceProvider);
  return forumService.getComments(postId);
});
