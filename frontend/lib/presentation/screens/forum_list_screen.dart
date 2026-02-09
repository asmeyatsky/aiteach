import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/providers/forum_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/widgets/responsive_layout.dart';
import 'package:frontend/presentation/widgets/loading_animation.dart';

class ForumListScreen extends ConsumerWidget {
  const ForumListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumPostsAsyncValue = ref.watch(forumPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Forum'),
      ),
      body: forumPostsAsyncValue.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(
              child: Text(
                'No posts yet. Be the first to start a discussion!',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            );
          }
          
          return AdaptivePadding(
            child: AdaptiveGridView(
              mobileCrossAxisCount: 1,
              tabletCrossAxisCount: 1,
              desktopCrossAxisCount: 2,
              children: List.generate(posts.length, (index) {
                final post = posts[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      context.go('/forum/posts/${post.id}', extra: post);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(post.body),
                          const SizedBox(height: 8),
                          Text('By: ${post.owner.username} on ${post.createdAt.toLocal().toString().split(' ')[0]}'),
                          Text('Comments: ${post.comments.length}'),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
        loading: () => const LoadingAnimation(),
        error: (error, stack) => Center(
          child: Text(
            'Failed to load forum posts. Please check your internet connection or try again later. Error: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/forum/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
