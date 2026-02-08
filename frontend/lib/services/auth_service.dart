import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/domain/entities/user.dart';
import 'package:frontend/domain/repositories/user_repository.dart';

class AuthService {
  final UserRepository _userRepository;
  static const String _tokenKey = 'jwt_token';
  static const _storage = FlutterSecureStorage();

  AuthService(this._userRepository);

  Future<String?> login(String username, String password) async {
    final token = await _userRepository.login(username, password);
    if (token != null) {
      await _saveToken(token);
    }
    return token;
  }

  Future<User> register(String username, String email, String password) async {
    return await _userRepository.register(username, email, password);
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<User?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) {
      return null;
    }
    return await _userRepository.getCurrentUser(token);
  }

  Future<bool> deleteUser(String username) async {
    return await _userRepository.deleteUser(username);
  }

  Future<User?> getUserById(int id) async {
    return await _userRepository.getUserById(id);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}
