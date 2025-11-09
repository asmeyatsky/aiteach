// frontend/lib/data/repositories/user_progress_repository_impl.dart
import 'package:frontend/data/datasources/user_progress_api_data_source.dart';
import 'package:frontend/data/mappers/user_progress_mapper.dart';
import 'package:frontend/domain/entities/user_progress.dart';
import 'package:frontend/domain/repositories/user_progress_repository.dart';

class UserProgressRepositoryImpl implements UserProgressRepository {
  final UserProgressApiDataSource apiDataSource;

  UserProgressRepositoryImpl(this.apiDataSource);

  @override
  Future<UserProgress> markLessonComplete(int lessonId, int userId) async {
    final userProgressModel = await apiDataSource.markLessonComplete(lessonId, userId);
    return UserProgressMapper.fromModel(userProgressModel);
  }

  @override
  Future<List<UserProgress>> getUserProgress(int userId) async {
    final userProgressModels = await apiDataSource.getUserProgress(userId);
    return userProgressModels.map((model) => UserProgressMapper.fromModel(model)).toList();
  }
}
