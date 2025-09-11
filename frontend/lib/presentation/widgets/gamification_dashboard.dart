import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/points_display.dart';
import 'package:frontend/presentation/widgets/leaderboard_widget.dart';

class GamificationDashboard extends StatelessWidget {
  final int points;
  final List<LeaderboardItem> leaderboardItems;

  const GamificationDashboard({
    super.key,
    required this.points,
    required this.leaderboardItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PointsDisplay(points: points),
        LeaderboardWidget(leaderboardItems: leaderboardItems),
      ],
    );
  }
}