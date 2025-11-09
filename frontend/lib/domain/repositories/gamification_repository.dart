// frontend/lib/domain/repositories/gamification_repository.dart
import 'package:frontend/domain/entities/badge.dart';
import 'package:frontend/domain/entities/user_badge.dart';

abstract class GamificationRepository {
  Future<List<Badge>> getBadges();
  Future<Badge> createBadge(String name, String description, String? iconUrl);
  Future<List<UserBadge>> getUserBadges(int userId);
  Future<UserBadge> createUserBadge(int userId, int badgeId);
}
