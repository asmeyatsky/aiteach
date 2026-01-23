// frontend/test/mocks/mock_auth_service.dart
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/domain/entities/user.dart';

class MockAuthService implements AuthService {
  User? _currentUser;
  String? _token;

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<String?> getToken() async {
    return _token;
  }

  @override
  Future<String?> login(String username, String password) async {
    if (username == 'testuser' && password == 'password123') {
      _currentUser = const User(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      );
      _token = 'mock_token';
      return _token;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _token = null;
  }

  @override
  Future<User> register(String username, String email, String password) async {
    if (username == 'newuser' && email == 'new@example.com' && password == 'password123') {
      _currentUser = const User(
        id: 2,
        username: 'newuser',
        email: 'new@example.com',
        createdAt: DateTime.now(),
      );
      return _currentUser!;
    }
    throw Exception('Registration failed');
  }

  @override
  Future<bool> deleteUser(String username) async {
    if (username == 'testuser') {
      _currentUser = null;
      _token = null;
      return true;
    }
    return false;
  }

  @override
  Future<User?> getUserById(int id) async {
    if (id == 1) {
      return _currentUser;
    }
    return null;
  }
}
