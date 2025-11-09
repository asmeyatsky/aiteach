// frontend/lib/data/mappers/badge_mapper.dart
import 'package:frontend/data/models/badge_model.dart';
import 'package:frontend/domain/entities/badge.dart';

class BadgeMapper {
  static Badge fromModel(BadgeModel model) {
    return Badge(
      id: model.id,
      name: model.name,
      description: model.description,
      iconUrl: model.iconUrl,
    );
  }

  static BadgeModel toModel(Badge entity) {
    return BadgeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      iconUrl: entity.iconUrl,
    );
  }
}
