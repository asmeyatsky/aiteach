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
    return await apiDataSource.deleteUser(username);
  }

  @override
  Future<User> getUserById(int id) async {
    final userModel = await apiDataSource.getUserById(id);
    return UserMapper.fromModel(userModel);
  }
}
