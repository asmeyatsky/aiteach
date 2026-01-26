import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/courses_provider.dart';
import 'package:frontend/providers/user_progress_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/widgets/course_progress_indicator.dart';
import 'package:frontend/presentation/widgets/lesson_card.dart';
import 'package:frontend/presentation/widgets/loading_animation.dart';

class CourseDetailsScreen extends ConsumerWidget {
  final int courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsyncValue = ref.watch(courseProvider(courseId));
    final lessonsAsyncValue = ref.watch(lessonsByCourseProvider(courseId));
    final userId = ref.watch(currentUserIdProvider);
    final userProgressAsyncValue = ref.watch(userProgressProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
      ),
      body: courseAsyncValue.when(
        data: (course) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                course.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              lessonsAsyncValue.when(
                data: (lessons) => userProgressAsyncValue.when(
                  data: (userProgress) {
                    final completedLessons = userProgress
                        .where((progress) => lessons.any((lesson) => lesson.id == progress.lessonId))
                        .length;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CourseProgressIndicator(
                          completedLessons: completedLessons,
                          totalLessons: lessons.length,
                        ),
                        const Text(
                          'Lessons',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            final isCompleted = userProgress.any((progress) => progress.lessonId == lesson.id);
                            return LessonCard(
                              lesson: lesson,
                              isCompleted: isCompleted,
                              index: index,
                              onTap: () {
                                context.go('/lessons/${lesson.id}', extra: lesson);
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                  loading: () => const LoadingAnimation(),
                  error: (error, stack) => Center(child: Text('Error loading user progress: $error')),
                ),
                loading: () => const LoadingAnimation(),
                error: (error, stack) => Center(child: Text('Error loading lessons: $error')),
              ),
            ],
          ),
        ),
        loading: () => const LoadingAnimation(),
        error: (error, stack) => Center(child: Text('Error loading course: $error')),
      ),
    );
  }
}
