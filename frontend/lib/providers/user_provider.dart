import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/providers/auth_provider.dart';

// Provider for the current user
final currentUserProvider = StateProvider<User?>((ref) => null);

// Provider for the current user ID
final currentUserIdProvider = Provider<int?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});

// Provider to fetch current user profile
final userProfileProvider = FutureProvider<User?>((ref) async {
  final authService = ref.read(authServiceProvider);
  final token = await authService.getToken();
  
  if (token == null) {
    return null;
  }
  
  // TODO: Implement actual user profile fetching
  // This would typically be an API call to get user details
  // For now, we'll return a mock user
  return User(
    id: 1,
    username: 'testuser',
    email: 'test@example.com',
    createdAt: DateTime.now(),
  );
});