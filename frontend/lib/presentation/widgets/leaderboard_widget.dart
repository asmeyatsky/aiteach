import 'package:flutter/material.dart';

class LeaderboardItem {
  final int rank;
  final String username;
  final int points;
  final bool isCurrentUser;

  LeaderboardItem({
    required this.rank,
    required this.username,
    required this.points,
    this.isCurrentUser = false,
  });
}

class LeaderboardWidget extends StatelessWidget {
  final List<LeaderboardItem> leaderboardItems;

  const LeaderboardWidget({super.key, required this.leaderboardItems});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Leaderboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leaderboardItems.length,
            itemBuilder: (context, index) {
              final item = leaderboardItems[index];
              return Container(
                decoration: item.isCurrentUser
                    ? BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(color: Colors.blue),
                      )
                    : null,
                child: ListTile(
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _getRankColor(item.rank),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${item.rank}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    item.username,
                    style: TextStyle(
                      fontWeight: item.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Text(
                    '${item.points} pts',
                    style: TextStyle(
                      fontWeight: item.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                      color: item.isCurrentUser ? Colors.blue : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }
}