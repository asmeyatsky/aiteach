// frontend/lib/data/mappers/user_proficiency_mapper.dart
import 'package:frontend/data/models/user_proficiency_model.dart';
import 'package:frontend/domain/entities/user_proficiency.dart';

class UserProficiencyMapper {
  static UserProficiency fromModel(UserProficiencyModel model) {
    return UserProficiency(
      id: model.id,
      userId: model.userId,
      skill: model.skill,
      level: model.level,
    );
  }

  static UserProficiencyModel toModel(UserProficiency entity) {
    return UserProficiencyModel(
      id: entity.id,
      userId: entity.userId,
      skill: entity.skill,
      level: entity.level,
    );
  }
}
