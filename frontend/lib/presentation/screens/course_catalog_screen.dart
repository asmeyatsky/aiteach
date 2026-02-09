import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/providers/courses_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/presentation/animations/animations.dart';
import 'package:frontend/presentation/widgets/loading_animation.dart';
import 'package:frontend/presentation/widgets/responsive_layout.dart';

class CourseCatalogScreen extends ConsumerWidget {
  const CourseCatalogScreen({super.key});

  Color _tierColor(String tier) {
    switch (tier) {
      case 'user':
        return AppColors.neonGreen;
      case 'builder':
        return AppColors.neonBlue;
      case 'innovator':
        return AppColors.neonPurple;
      default:
        return AppColors.neonCyan;
    }
  }

  String _tierLabel(String tier) {
    switch (tier) {
      case 'user':
        return 'AI for Everyone';
      case 'builder':
        return 'Developer';
      case 'innovator':
        return 'Researcher';
      default:
        return tier;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsyncValue = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Catalog'),
      ),
      body: coursesAsyncValue.when(
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(
              child: Text(
                'No courses available yet. Please check back later!',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Continue your AI learning journey',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  AdaptivePadding(
                    child: AdaptiveGridView(
                      mobileCrossAxisCount: 1,
                      tabletCrossAxisCount: 2,
                      desktopCrossAxisCount: 3,
                      children: List.generate(courses.length, (index) {
                        final course = courses[index];
                        return SlideInAnimation(
                          delay: Duration(milliseconds: 50 * index),
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                context.go('/courses/${course.id}');
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _tierColor(course.tier).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            _tierLabel(course.tier),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: _tierColor(course.tier),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        if (course.provider != null) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.border,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              course.provider!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      course.title,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      course.description,
                                      style: const TextStyle(color: AppColors.textSecondary),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingAnimation(),
        error: (error, stack) {
          String errorMessage = 'Failed to load courses.';
          if (error is ApiException) {
            errorMessage = error.message;
          } else {
            errorMessage = 'An unexpected error occurred: ${error.toString()}';
          }
          return Center(
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        },
      ),
    );
  }
}
