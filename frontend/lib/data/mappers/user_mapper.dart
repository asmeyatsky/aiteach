// frontend/lib/data/mappers/user_mapper.dart
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/domain/entities/user.dart';

class UserMapper {
  static User fromModel(UserModel model) {
    return User(
      id: model.id,
      username: model.username,
      email: model.email,
      profilePictureUrl: model.profilePictureUrl,
      createdAt: model.createdAt,
    );
  }

  static UserModel toModel(User entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      profilePictureUrl: entity.profilePictureUrl,
      createdAt: entity.createdAt,
    );
  }
}
