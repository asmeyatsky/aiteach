import 'package:flutter/material.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/data/models/user_badge_model.dart';
import 'package:frontend/presentation/widgets/badge_card.dart';

class BadgesGrid extends StatelessWidget {
  final List<UserBadgeModel> userBadges;

  const BadgesGrid({super.key, required this.userBadges});

  @override
  Widget build(BuildContext context) {
    if (userBadges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 60,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No badges earned yet',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete lessons and participate in the community to earn badges!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Badges (${userBadges.length})',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userBadges.length,
          itemBuilder: (context, index) {
            return BadgeCard(userBadge: userBadges[index]);
          },
        ),
      ],
    );
  }
}