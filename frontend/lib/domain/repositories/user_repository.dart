// frontend/lib/domain/repositories/user_repository.dart
import 'package:frontend/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> register(String username, String email, String password);
  Future<String> login(String username, String password); // Returns token
  Future<User> getCurrentUser(String token);
  Future<bool> deleteUser(String username);
  Future<User> getUserById(int id);
}
