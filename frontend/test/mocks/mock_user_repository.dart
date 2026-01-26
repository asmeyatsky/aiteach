import 'package:frontend/domain/entities/user.dart';
import 'package:frontend/domain/repositories/user_repository.dart';
import 'package:frontend/utils/exceptions.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<User> register(String username, String email, String password) async {
    return User(
      id: 1,
      username: username,
      email: email,
      profilePictureUrl: null,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<String?> login(String username, String password) async {
    if (username == 'testuser' && password == 'password123') {
      return 'mock_token';
    }
    throw ApiException('Invalid credentials');
  }

  @override
  Future<User?> getCurrentUser(String token) async {
    if (token == 'mock_token') {
      return User(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        profilePictureUrl: null,
        createdAt: DateTime.now(),
      );
    }
    throw ApiException('Invalid token');
  }

  @override
  Future<bool> deleteUser(String username) async {
    return true;
  }

  @override
  Future<User?> getUserById(int id) async {
    return User(
      id: id,
      username: 'testuser_$id',
      email: 'test_$id@example.com',
      profilePictureUrl: null,
      createdAt: DateTime.now(),
    );
  }
}
