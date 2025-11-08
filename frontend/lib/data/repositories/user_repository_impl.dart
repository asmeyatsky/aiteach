// frontend/lib/data/repositories/user_repository_impl.dart
import 'package:frontend/data/datasources/user_api_data_source.dart';
import 'package:frontend/data/mappers/user_mapper.dart';
import 'package:frontend/domain/entities/user.dart';
import 'package:frontend/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiDataSource apiDataSource;

  UserRepositoryImpl(this.apiDataSource);

  @override
  Future<User> register(String username, String email, String password) async {
    final userModel = await apiDataSource.register(username, email, password);
    return UserMapper.fromModel(userModel);
  }

  @override
  Future<String> login(String username, String password) async {
    return await apiDataSource.login(username, password);
  }

  @override
  Future<User> getCurrentUser(String token) async {
    final userModel = await apiDataSource.getCurrentUser(token);
    return UserMapper.fromModel(userModel);
  }

  @override
  Future<bool> deleteUser(String username) async {
    // This method needs the token, which is currently managed by AuthService.
    // For now, we'll assume the token is handled externally or passed.
    // This highlights a need for a more robust authentication flow.
    // For testing purposes, we might need to pass the token here.
    // Or, the repository could depend on a token manager.
    // For now, let's assume the token is available.
    // This will be addressed when refactoring AuthService.
    return await apiDataSource.deleteUser(username, "dummy_token"); // TODO: Replace with actual token
  }

  @override
  Future<User> getUserById(int id) async {
    // This method needs the token, which is currently managed by AuthService.
    // For now, we'll assume the token is handled externally or passed.
    // This highlights a need for a more robust authentication flow.
    // For testing purposes, we might need to pass the token here.
    // Or, the repository could depend on a token manager.
    // For now, let's assume the token is available.
    // This will be addressed when refactoring AuthService.
    final userModel = await apiDataSource.getUserById(id, "dummy_token"); // TODO: Replace with actual token
    return UserMapper.fromModel(userModel);
  }
}
