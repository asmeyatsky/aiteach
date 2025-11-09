// frontend/lib/domain/entities/user_badge.dart
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/badge.dart'; // Assuming Badge entity exists

class UserBadge extends Equatable {
  final int id;
  final int userId;
  final int badgeId;
  final DateTime awardedAt;
  final Badge badge; // Assuming badge is always loaded with the user badge

  const UserBadge({
    required this.id,
    required this.userId,
    required this.badgeId,
    required this.awardedAt,
    required this.badge,
  });

  @override
  List<Object?> get props => [id, userId, badgeId, awardedAt, badge];
}
