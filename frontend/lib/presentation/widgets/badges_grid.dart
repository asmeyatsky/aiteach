import 'package:flutter/material.dart';
import 'package:frontend/models/user_badge.dart';
import 'package:frontend/presentation/widgets/badge_card.dart';

class BadgesGrid extends StatelessWidget {
  final List<UserBadge> userBadges;

  const BadgesGrid({super.key, required this.userBadges});

  @override
  Widget build(BuildContext context) {
    if (userBadges.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No badges earned yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Complete lessons and participate in the community to earn badges!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
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