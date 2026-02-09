import 'package:flutter/material.dart';
import 'package:frontend/config/app_colors.dart';

class CourseProgressIndicator extends StatelessWidget {
  final int completedLessons;
  final int totalLessons;

  const CourseProgressIndicator({
    super.key,
    required this.completedLessons,
    required this.totalLessons,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedLessons of $totalLessons lessons completed',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}