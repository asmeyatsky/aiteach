import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/datasources/gamification_api_data_source.dart';
import 'package:frontend/data/repositories/gamification_repository_impl.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/data/mappers/user_badge_mapper.dart';
import 'package:frontend/data/models/user_badge_model.dart';

final gamificationApiDataSourceProvider = Provider<GamificationApiDataSource>((ref) {
  return GamificationApiDataSource(ref.read(dioProvider));
});

final gamificationRepositoryProvider = Provider<GamificationRepositoryImpl>((ref) {
  return GamificationRepositoryImpl(ref.read(gamificationApiDataSourceProvider));
});

final userBadgesProvider = FutureProvider.family<List<UserBadgeModel>, int?>((ref, userId) async {
  if (userId == null) {
    return [];
  }
  final gamificationRepository = ref.read(gamificationRepositoryProvider);
  final userBadges = await gamificationRepository.getUserBadges(userId);
  return userBadges.map((badge) => UserBadgeMapper.toModel(badge)).toList();
});
