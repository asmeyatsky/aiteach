// frontend/lib/data/repositories/gamification_repository_impl.dart
import 'package:frontend/data/datasources/gamification_api_data_source.dart';
import 'package:frontend/data/mappers/badge_mapper.dart';
import 'package:frontend/data/mappers/user_badge_mapper.dart';
import 'package:frontend/domain/entities/badge.dart';
import 'package:frontend/domain/entities/user_badge.dart';
import 'package:frontend/domain/repositories/gamification_repository.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationApiDataSource apiDataSource;

  GamificationRepositoryImpl(this.apiDataSource);

  @override
  Future<List<Badge>> getBadges() async {
    final badgeModels = await apiDataSource.getBadges();
    return badgeModels.map((model) => BadgeMapper.fromModel(model)).toList();
  }

  @override
  Future<Badge> createBadge(String name, String description, String? iconUrl) async {
    final badgeModel = await apiDataSource.createBadge(name, description, iconUrl);
    return BadgeMapper.fromModel(badgeModel);
  }

  @override
  Future<List<UserBadge>> getUserBadges(int userId) async {
    final userBadgeModels = await apiDataSource.getUserBadges(userId);
    return userBadgeModels.map((model) => UserBadgeMapper.fromModel(model)).toList();
  }

  @override
  Future<UserBadge> createUserBadge(int userId, int badgeId) async {
    final userBadgeModel = await apiDataSource.createUserBadge(userId, badgeId);
    return UserBadgeMapper.fromModel(userBadgeModel);
  }
}
