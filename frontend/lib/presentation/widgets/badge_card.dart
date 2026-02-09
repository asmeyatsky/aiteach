import 'package:flutter/material.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/data/models/user_badge_model.dart';

class BadgeCard extends StatelessWidget {
  final UserBadgeModel userBadge;

  const BadgeCard({super.key, required this.userBadge});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.neonCyan, width: 2),
              ),
              child: userBadge.badge.iconUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        userBadge.badge.iconUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.emoji_events, color: AppColors.neonCyan);
                        },
                      ),
                    )
                  : Icon(Icons.emoji_events, color: AppColors.neonCyan, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userBadge.badge.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userBadge.badge.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Awarded on ${userBadge.awardedAt.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}