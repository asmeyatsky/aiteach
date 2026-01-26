// frontend/lib/data/mappers/user_profile_mapper.dart
import 'package:frontend/data/models/user_profile_model.dart';
import 'package:frontend/domain/entities/user_profile.dart';
import 'package:frontend/data/mappers/user_proficiency_mapper.dart';

class UserProfileMapper {
  static UserProfile fromModel(UserProfileModel model) {
    return UserProfile(
      id: model.id,
      username: model.username,
      email: model.email,
      profilePictureUrl: model.profilePictureUrl,
      createdAt: model.createdAt,
      proficiencies: model.proficiencies?.map((p) {
        // Convert UserProficiencyModel to UserProficiency entity
        return UserProficiencyMapper.fromModel(p);
      }).toList() ?? [],
    );
  }

  static UserProfileModel toModel(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      profilePictureUrl: entity.profilePictureUrl,
      createdAt: entity.createdAt,
      proficiencies: entity.proficiencies.map((p) {
        // Convert UserProficiency entity to UserProficiencyModel
        return UserProficiencyMapper.toModel(p);
      }).toList(),
    );
  }
}
