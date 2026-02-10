import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/data/models/lesson_model.dart';
import 'package:frontend/providers/courses_provider.dart';
import 'package:frontend/providers/user_progress_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/presentation/widgets/lesson_content_view.dart';
import 'package:frontend/presentation/widgets/animated_button.dart';
import 'package:frontend/presentation/widgets/loading_animation.dart';
import 'package:go_router/go_router.dart';

class LessonViewScreen extends ConsumerWidget {
  final LessonModel lesson;

  const LessonViewScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    final userProgressAsyncValue = ref.watch(currentUserProgressProvider);
    final lessonsAsyncValue = ref.watch(lessonsByCourseProvider(lesson.courseId));

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: userProgressAsyncValue.when(
        data: (userProgress) {
          final isCompleted = userProgress.any((progress) => progress.lessonId == lesson.id);

          // Find next lesson from the course's lesson list
          LessonModel? nextLesson;
          final lessonsData = lessonsAsyncValue.valueOrNull;
          if (lessonsData != null) {
            final sorted = [...lessonsData]..sort((a, b) => a.order.compareTo(b.order));
            final currentIndex = sorted.indexWhere((l) => l.id == lesson.id);
            if (currentIndex != -1 && currentIndex < sorted.length - 1) {
              nextLesson = sorted[currentIndex + 1];
            }
          }

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
                        color: isCompleted ? AppColors.neonGreen : AppColors.neonCyan,
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
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lesson.contentType,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
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
                            final userProgressRepository = ref.read(userProgressRepositoryProvider);
                            final success = await userProgressRepository.markLessonComplete(lesson.id, userId);
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
                        color: AppColors.neonGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neonGreen),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: AppColors.neonGreen),
                          SizedBox(width: 8),
                          Text(
                            'Lesson Completed!',
                            style: TextStyle(
                              color: AppColors.neonGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Next lesson navigation
                if (nextLesson != null) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.go('/lessons/${nextLesson!.id}', extra: nextLesson);
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text('Next: ${nextLesson.title}'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.neonCyan,
                        side: const BorderSide(color: AppColors.neonCyan),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
                // Back to course
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      context.go('/courses/${lesson.courseId}');
                    },
                    icon: const Icon(Icons.list, size: 18),
                    label: const Text('Back to Course'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
