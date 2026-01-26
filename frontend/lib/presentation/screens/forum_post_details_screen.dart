import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/forum_post.dart';
import 'package:frontend/providers/forum_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/exceptions.dart';

class ForumPostDetailsScreen extends ConsumerWidget {
  final ForumPost post;

  const ForumPostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsyncValue = ref.watch(forumCommentsProvider(post.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.body,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'By: ${post.owner.username} on ${post.createdAt.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            commentsAsyncValue.when(
              data: (comments) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.body),
                          const SizedBox(height: 4),
                          Text(
                            'By: ${comment.owner.username} on ${comment.createdAt.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error loading comments: $error')),
            ),
            const SizedBox(height: 20),
            // Comment form
            CommentForm(postId: post.id),
          ],
        ),
      ),
    );
  }
}

class CommentForm extends ConsumerStatefulWidget {
  final int postId;

  const CommentForm({super.key, required this.postId});

  @override
  ConsumerState<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends ConsumerState<CommentForm> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forumRepository = ref.read(forumRepositoryProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Column(
      children: [
        TextFormField(
          controller: _commentController,
          decoration: const InputDecoration(
            labelText: 'Add a comment',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: userId == null
              ? null
              : () async {
                  if (_commentController.text.isNotEmpty) {
                    try {
                      final success = await forumRepository.createComment(
                        widget.postId,
                        _commentController.text,
                      );
                      if (success != null) {
                        _commentController.clear();
                        ref.invalidate(forumCommentsProvider(widget.postId));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add comment.')),
                        );
                      }
                    } catch (e) {
                      String errorMessage = 'Failed to add comment.';
                      if (e is ApiException) {
                        errorMessage = e.message;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                    }
                  }
                },
          child: const Text('Add Comment'),
        ),
      ],
    );
  }
}
