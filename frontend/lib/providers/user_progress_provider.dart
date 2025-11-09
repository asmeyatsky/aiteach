import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/user_progress.dart';
import 'package:frontend/data/datasources/user_progress_api_data_source.dart';
import 'package:frontend/data/repositories/user_progress_repository_impl.dart';
import 'package:frontend/providers/auth_provider.dart'; // To get Dio instance
import 'package:frontend/providers/user_provider.dart'; // To get currentUserIdProvider

final userProgressApiDataSourceProvider = Provider<UserProgressApiDataSource>((ref) {
  return UserProgressApiDataSource(ref.read(dioProvider));
});

final userProgressRepositoryProvider = Provider<UserProgressRepositoryImpl>((ref) {
  return UserProgressRepositoryImpl(ref.read(userProgressApiDataSourceProvider));
});

final userProgressProvider = FutureProvider.family<List<UserProgress>, int?>((ref, userId) async {
  if (userId == null) {
    return [];
  }
  final userProgressRepository = ref.read(userProgressRepositoryProvider);
  return userProgressRepository.getUserProgress(userId);
});

// Provider that automatically uses the current user's ID
final currentUserProgressProvider = FutureProvider<List<UserProgress>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return [];
  }
  final userProgressAsync = ref.watch(userProgressProvider(userId));
  return userProgressAsync.maybeWhen(
    data: (data) => data,
    orElse: () => [],
  );
});