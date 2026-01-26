import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/data/mappers/user_mapper.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authService = ref.read(authServiceProvider);
    final token = await authService.getToken();

    if (mounted) {
      if (token != null) {
        // Set current user when logged in
        ref.read(currentUserProvider.notifier).state = UserMapper.fromModel(UserModel(
          id: 1,
          username: 'testuser',
          email: 'test@example.com',
          createdAt: DateTime.now(),
        ));
        context.go('/'); // Navigate to home if logged in
      } else {
        context.go('/login'); // Navigate to login if not logged in
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Or your app logo/animation
      ),
    );
  }
}
