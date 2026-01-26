import 'package:frontend/domain/entities/user.dart';
import 'package:frontend/domain/repositories/user_repository.dart';
import 'package:frontend/services/auth_service.dart';

class MockAuthService implements AuthService {
  final UserRepository _userRepository;

  MockAuthService(this._userRepository);

  @override
  Future<String?> login(String username, String password) async {
    return _userRepository.login(username, password);
  }

  @override
  Future<User> register(String username, String email, String password) async {
    return _userRepository.register(username, email, password);
  }

  @override
  Future<void> logout() async {
    // Mock implementation for logout, no userRepository method to call
  }

  @override
  Future<String?> getToken() async {
    return 'mock_token'; // Always return a mock token for testing purposes
  }

  @override
  Future<User?> getCurrentUser() async {
    return _userRepository.getCurrentUser('mock_token'); // Use repository to get user
  }

  @override
  Future<bool> deleteUser(String username) async {
    return _userRepository.deleteUser(username);
  }

  @override
  Future<User?> getUserById(int id) async {
    return _userRepository.getUserById(id);
  }
}