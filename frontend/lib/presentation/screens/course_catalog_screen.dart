import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/providers/courses_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/exceptions.dart';
import 'package:frontend/presentation/animations/animations.dart';
import 'package:frontend/presentation/widgets/loading_animation.dart';
import 'package:frontend/presentation/widgets/responsive_layout.dart';
import 'package:frontend/presentation/widgets/course_recommendations.dart';
import 'package:frontend/services/course_recommendation_service.dart';
import 'package:frontend/domain/value_objects/proficiency_level.dart';

class CourseCatalogScreen extends ConsumerWidget {
  const CourseCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsyncValue = ref.watch(coursesProvider);
    // For demo purposes, we'll use a mock proficiency level
    // In a real app, this would come from the user's profile
    final userProficiencyLevel = ProficiencyLevel.beginner;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
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
                  // Welcome section
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
                  
                  // Recommended courses section
                  RecommendedCoursesSection(
                    userLevel: userProficiencyLevel,
                    onViewAll: () {
                      // TODO: Navigate to filtered course list
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Popular courses section
                  PopularCoursesSection(
                    onViewAll: () {
                      // TODO: Navigate to popular courses list
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // All courses section
                  const Text(
                    'All Courses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  AdaptivePadding(
                    child: AdaptiveGridView(
                      mobileCrossAxisCount: 1,
                      tabletCrossAxisCount: 2,
                      desktopCrossAxisCount: 3,
                      children: List.generate(courses.length, (index) {
                        return SlideInAnimation(
                          delay: Duration(milliseconds: 100 * index),
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                context.go('/courses/${courses[index].id}');
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      courses[index].title,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(courses[index].description),
                                    const SizedBox(height: 8),
                                    Text('Tier: ${courses[index].tier}'),
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
