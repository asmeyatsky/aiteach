import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/gamification_service.dart';
import 'package:frontend/models/user_profile.dart';
import 'package:frontend/models/user_badge.dart';
import 'package:frontend/providers/auth_provider.dart';

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  final authService = ref.read(authServiceProvider);
  return GamificationService(authService);
});

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

final userBadgesProvider = FutureProvider.family<List<UserBadge>, int?>((ref, userId) async {
  if (userId == null) {
    return [];
  }
  final gamificationService = ref.read(gamificationServiceProvider);
  return gamificationService.getUserBadges(userId);
});
