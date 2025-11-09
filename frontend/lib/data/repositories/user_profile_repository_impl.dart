// frontend/lib/data/repositories/user_profile_repository_impl.dart
import 'package:frontend/data/datasources/user_profile_api_data_source.dart';
import 'package:frontend/data/mappers/user_profile_mapper.dart';
import 'package:frontend/data/mappers/user_proficiency_mapper.dart';
import 'package:frontend/domain/entities/user_profile.dart';
import 'package:frontend/domain/entities/user_proficiency.dart';
import 'package:frontend/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileApiDataSource apiDataSource;

  UserProfileRepositoryImpl(this.apiDataSource);

  @override
  Future<UserProfile> getUserProfile(int userId) async {
    final userProfileModel = await apiDataSource.getUserProfile(userId);
    return UserProfileMapper.fromModel(userProfileModel);
  }

  @override
  Future<UserProficiency> updateUserProficiency(int userId, String skill, int level) async {
    final userProficiencyModel = await apiDataSource.setUserProficiency(userId, skill, level);
    return UserProficiencyMapper.fromModel(userProficiencyModel);
  }
}
