// frontend/lib/data/mappers/user_skill_proficiency_mapper.dart
import 'package:frontend/data/models/user_skill_proficiency_model.dart';
import 'package:frontend/domain/entities/user_proficiency.dart';

class UserSkillProficiencyMapper {
  static UserProficiency fromModel(UserSkillProficiencyModel model) {
    return UserProficiency(
      id: model.id,
      userId: model.userId,
      skill: model.skill,
      level: model.level,
    );
  }

  static UserSkillProficiencyModel toModel(UserProficiency entity) {
    return UserSkillProficiencyModel(
      id: entity.id,
      userId: entity.userId,
      skill: entity.skill,
      level: entity.level,
    );
  }
}
