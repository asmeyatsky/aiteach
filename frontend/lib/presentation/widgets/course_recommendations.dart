import 'package:flutter/material.dart';
import 'package:frontend/services/course_recommendation_service.dart';
import 'package:go_router/go_router.dart';

class RecommendedCoursesSection extends StatelessWidget {
  final ProficiencyLevel userLevel;
  final VoidCallback onViewAll;

  const RecommendedCoursesSection({
    super.key,
    required this.userLevel,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final recommendedCourses = CourseRecommendationService.getRecommendedCourses(userLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended for ${_getLevelName(userLevel)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
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
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No courses available for this level yet.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _getLevelName(ProficiencyLevel level) {
    switch (level) {
      case ProficiencyLevel.beginner:
        return 'Beginners';
      case ProficiencyLevel.intermediate:
        return 'Intermediate Learners';
      case ProficiencyLevel.advanced:
        return 'Advanced Practitioners';
    }
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
              // Course header with category badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getLevelColor(course.recommendedLevel),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getLevelName(course.recommendedLevel),
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
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.category,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Course content
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
                          color: Colors.grey,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${course.estimatedHours} hours'),
                          const SizedBox(width: 16),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
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
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
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
              
              // Action button
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

  Color _getLevelColor(ProficiencyLevel level) {
    switch (level) {
      case ProficiencyLevel.beginner:
        return Colors.green;
      case ProficiencyLevel.intermediate:
        return Colors.orange;
      case ProficiencyLevel.advanced:
        return Colors.red;
    }
  }

  String _getLevelName(ProficiencyLevel level) {
    switch (level) {
      case ProficiencyLevel.beginner:
        return 'Beginner';
      case ProficiencyLevel.intermediate:
        return 'Intermediate';
      case ProficiencyLevel.advanced:
        return 'Advanced';
    }
  }
}

class PopularCoursesSection extends StatelessWidget {
  final VoidCallback onViewAll;

  const PopularCoursesSection({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final popularCourses = CourseRecommendationService.getPopularCourses();

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
        SizedBox(
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
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No popular courses available yet.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}