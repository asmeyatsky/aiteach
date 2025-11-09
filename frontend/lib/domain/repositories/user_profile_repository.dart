// frontend/lib/domain/repositories/user_profile_repository.dart
import 'package:frontend/domain/entities/user_profile.dart';
import 'package:frontend/domain/entities/user_proficiency.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getUserProfile(int userId);
  Future<UserProficiency> updateUserProficiency(int userId, String skill, int level);
}
