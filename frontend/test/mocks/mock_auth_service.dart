import 'package:frontend/domain/entities/user.dart';

class MockAuthService {
  Future<User?> login(String username, String password) async {
    // Mock implementation
    return User(
      id: 1,
      username: username,
      email: '$username@example.com',
      createdAt: DateTime.now(),
    );
  }

  Future<User?> register(String username, String email, String password) async {
    // Mock implementation
    return User(
      id: 2,
      username: username,
      email: email,
      createdAt: DateTime.now(),
    );
  }

  Future<void> logout() async {
    // Mock implementation
  }
}