import 'package:frontend/domain/entities/user_progress.dart';

abstract class UserProgressRepository {
  Future<UserProgress> markLessonComplete(int lessonId, int userId);
  Future<List<UserProgress>> getUserProgress(int userId);
}
