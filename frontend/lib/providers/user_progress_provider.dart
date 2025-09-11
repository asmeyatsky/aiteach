import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/course_service.dart';
import 'package:frontend/models/user_progress.dart';
import 'package:frontend/providers/courses_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/providers/auth_provider.dart';

final userProgressProvider = FutureProvider.family<List<UserProgress>, int?>((ref, userId) async {
  if (userId == null) {
    return [];
  }
  final courseService = ref.read(courseServiceProvider);
  return courseService.getUserProgress(userId);
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
