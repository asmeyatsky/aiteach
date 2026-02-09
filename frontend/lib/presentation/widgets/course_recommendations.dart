import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/domain/entities/course_recommendation.dart';
import 'package:frontend/domain/value_objects/proficiency_level.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/course_recommendation_provider.dart';
import 'package:frontend/providers/user_provider.dart';

String getLevelDisplayName(ProficiencyLevel level) {
  switch (level) {
    case ProficiencyLevel.beginner:
      return 'Beginners';
    case ProficiencyLevel.intermediate:
      return 'Intermediate Learners';
    case ProficiencyLevel.advanced:
      return 'Advanced Practitioners';
  }
}

String getLevelShortName(ProficiencyLevel level) {
  switch (level) {
    case ProficiencyLevel.beginner:
      return 'Beginner';
    case ProficiencyLevel.intermediate:
      return 'Intermediate';
    case ProficiencyLevel.advanced:
      return 'Advanced';
  }
}

Color getLevelColor(ProficiencyLevel level) {
  switch (level) {
    case ProficiencyLevel.beginner:
      return AppColors.neonGreen;
    case ProficiencyLevel.intermediate:
      return AppColors.warning;
    case ProficiencyLevel.advanced:
      return AppColors.error;
  }
}

class RecommendedCoursesSection extends ConsumerWidget {
  final ProficiencyLevel userLevel;
  final VoidCallback onViewAll;

  const RecommendedCoursesSection({
    super.key,
    required this.userLevel,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final recommendedCoursesAsync = ref.watch(recommendedCoursesProvider(currentUserId ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended for ${getLevelDisplayName(userLevel)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        recommendedCoursesAsync.when(
          data: (recommendedCourses) {
            return SizedBox(
              height: 250,
              child: recommendedCourses.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedCourses.length,
                      itemBuilder: (context, index) {
                        final course = recommendedCourses[index];
                        return _CourseCard(course: course);
                      },
                    ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 60,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          const Text(
            'No courses available for this level yet.',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseRecommendation course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () {
            context.go('/courses/${course.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getLevelColor(course.recommendedLevel),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getLevelShortName(course.recommendedLevel),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.category,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text('${course.estimatedHours} hours'),
                          const SizedBox(width: 16),
                          Icon(Icons.star, size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text('${course.rating}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: course.skillsCovered.take(3).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.neonCyan.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.neonCyan,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/courses/${course.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Start Learning'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// PopularCoursesSection reuses the recommended courses provider since
// there is no separate backend endpoint for popular courses yet.
class PopularCoursesSection extends ConsumerWidget {
  final VoidCallback onViewAll;

  const PopularCoursesSection({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final popularCoursesAsync = ref.watch(recommendedCoursesProvider(currentUserId ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Most Popular Courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        popularCoursesAsync.when(
          data: (popularCourses) {
            return SizedBox(
              height: 250,
              child: popularCourses.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularCourses.length,
                      itemBuilder: (context, index) {
                        final course = popularCourses[index];
                        return _CourseCard(course: course);
                      },
                    ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up_outlined,
            size: 60,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          const Text(
            'No popular courses available yet.',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
