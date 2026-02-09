import 'package:flutter/material.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/data/models/lesson_model.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/animations/animations.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final bool isCompleted;
  final VoidCallback onTap;
  final int index;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.isCompleted,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SlideInAnimation(
      delay: Duration(milliseconds: 100 * index),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.neonGreen : AppColors.neonCyan,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : _getIconForContentType(lesson.contentType),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.contentType,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.neonGreen,
                    size: 24,
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForContentType(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'text':
        return Icons.article;
      case 'video':
        return Icons.play_circle_fill;
      case 'quiz':
        return Icons.quiz;
      default:
        return Icons.article;
    }
  }
}