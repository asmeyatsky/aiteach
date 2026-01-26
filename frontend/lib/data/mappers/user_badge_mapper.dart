// frontend/lib/data/mappers/user_badge_mapper.dart
import 'package:frontend/data/models/user_badge_model.dart';
import 'package:frontend/domain/entities/user_badge.dart';
import 'package:frontend/data/mappers/badge_mapper.dart';

class UserBadgeMapper {
  static UserBadge fromModel(UserBadgeModel model) {
    return UserBadge(
      id: model.id,
      userId: model.userId,
      badgeId: model.badgeId,
      awardedAt: model.awardedAt,
      badge: BadgeMapper.fromModel(model.badge),
    );
  }

  static UserBadgeModel toModel(UserBadge entity) {
    return UserBadgeModel(
      id: entity.id,
      userId: entity.userId,
      badgeId: entity.badgeId,
      awardedAt: entity.awardedAt,
      badge: BadgeMapper.toModel(entity.badge),
    );
  }
}
