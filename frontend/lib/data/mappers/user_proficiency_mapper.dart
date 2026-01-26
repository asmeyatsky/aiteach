// frontend/lib/data/mappers/user_proficiency_mapper.dart
import 'package:frontend/data/models/user_proficiency_model.dart';
import 'package:frontend/domain/entities/user_proficiency.dart';

class UserProficiencyMapper {
  static UserProficiency fromModel(UserProficiencyModel model) {
    return UserProficiency(
      id: model.userId, // Assuming userId from the model maps to id in entity
      userId: model.userId,
      skill: '', // Default value since UserProficiencyModel doesn't have a skill field
      level: model.selectedLevel.index, // Convert enum to int
    );
  }

  static UserProficiencyModel toModel(UserProficiency entity) {
    return UserProficiencyModel(
      userId: entity.userId,
      selectedLevel: ProficiencyLevel.values[entity.level], // Convert int to enum
      assessmentScore: 0.0, // Default value
      lastUpdated: DateTime.now(), // Default value
    );
  }
}
