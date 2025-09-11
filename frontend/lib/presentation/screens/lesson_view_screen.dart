import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/lesson.dart';
import 'package:frontend/providers/courses_provider.dart';
import 'package:frontend/providers/user_progress_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/presentation/widgets/lesson_content_view.dart';
import 'package:frontend/presentation/widgets/animated_button.dart';
import 'package:frontend/presentation/widgets/loading_animation.dart';

class LessonViewScreen extends ConsumerWidget {
  final Lesson lesson;

  const LessonViewScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    final userProgressAsyncValue = ref.watch(currentUserProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: userProgressAsyncValue.when(
        data: (userProgress) {
          final isCompleted = userProgress.any((progress) => progress.lessonId == lesson.id);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isCompleted ? 'Completed' : 'In Progress',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lesson.contentType,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LessonContentView(
                  contentType: lesson.contentType,
                  contentData: lesson.contentData,
                ),
                const SizedBox(height: 30),
                if (!isCompleted && userId != null)
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: AnimatedButton(
                        onPressed: () async {
                          try {
                            final courseService = ref.read(courseServiceProvider);
                            final success = await courseService.markLessonComplete(lesson.id, userId);
                            if (success != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Lesson marked as complete!')),
                              );
                              ref.invalidate(currentUserProgressProvider);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to mark lesson as complete.')),
                              );
                            }
                          } catch (e) {
                            String errorMessage = 'Failed to mark lesson as complete.';
                            if (e is ApiException) {
                              errorMessage = e.message;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          }
                        },
                        child: const Text('Mark as Complete'),
                      ),
                    ),
                  )
                else if (isCompleted)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Lesson Completed!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const LoadingAnimation(),
        error: (error, stack) => Center(
          child: Text('Error loading user progress: $error'),
        ),
      ),
    );
  }
}
