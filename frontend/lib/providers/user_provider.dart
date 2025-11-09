import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/user.dart';
import 'package:frontend/domain/entities/user_profile.dart';
import 'package:frontend/data/datasources/user_profile_api_data_source.dart';
import 'package:frontend/data/repositories/user_profile_repository_impl.dart';
import 'package:frontend/providers/auth_provider.dart'; // To get Dio instance

// Provider for the current user
final currentUserProvider = StateProvider<User?>((ref) => null);

// Provider for the current user ID
final currentUserIdProvider = Provider<int?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});

final userProfileApiDataSourceProvider = Provider<UserProfileApiDataSource>((ref) {
  return UserProfileApiDataSource(ref.read(dioProvider));
});

final userProfileRepositoryProvider = Provider<UserProfileRepositoryImpl>((ref) {
  return UserProfileRepositoryImpl(ref.read(userProfileApiDataSourceProvider));
});

// Provider to fetch current user profile
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return null;
  }
  final userProfileRepository = ref.read(userProfileRepositoryProvider);
  return userProfileRepository.getUserProfile(userId);
});
