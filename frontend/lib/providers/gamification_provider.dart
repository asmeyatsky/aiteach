import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/user_badge.dart';
import 'package:frontend/data/datasources/gamification_api_data_source.dart';
import 'package:frontend/data/repositories/gamification_repository_impl.dart';
import 'package:frontend/providers/auth_provider.dart'; // To get Dio instance
import 'package:frontend/data/mappers/user_badge_mapper.dart';
import 'package:frontend/data/models/user_badge_model.dart';

final gamificationApiDataSourceProvider = Provider<GamificationApiDataSource>((ref) {
  return GamificationApiDataSource(ref.read(dioProvider));
});

final gamificationRepositoryProvider = Provider<GamificationRepositoryImpl>((ref) {
  return GamificationRepositoryImpl(ref.read(gamificationApiDataSourceProvider));
});

// TODO: gamificationUserProfileProvider uses getUserProfile, which is a user-related method.
// This should be moved to UserRepository and then accessed via authServiceProvider.
// For now, commenting it out to avoid compilation errors.
/*
final gamificationUserProfileProvider = FutureProvider.family<UserProfile?, int?>((ref, userId) async {
  if (userId == null) {
    return null;
  }
  final gamificationService = ref.read(gamificationServiceProvider);
  try {
    // Try to fetch actual user profile
    final profile = await gamificationService.getUserProfile(userId);
    return profile;
  } catch (e) {
    // If fetching fails, return a mock profile
    return UserProfile(
      id: userId,
      username: 'testuser',
      email: 'test@example.com',
      profilePictureUrl: null,
      createdAt: DateTime.now(),
    );
  }
});
*/

final userBadgesProvider = FutureProvider.family<List<UserBadgeModel>, int?>((ref, userId) async {
  if (userId == null) {
    return [];
  }
  final gamificationRepository = ref.read(gamificationRepositoryProvider);
  final userBadges = await gamificationRepository.getUserBadges(userId);
  return userBadges.map((badge) => UserBadgeMapper.toModel(badge)).toList();
});