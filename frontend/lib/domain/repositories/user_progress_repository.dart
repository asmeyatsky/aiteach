// frontend/lib/domain/repositories/user_progress_repository.dart
import 'package:frontend/domain/entities/user_progress.dart';
import 'package:frontend/domain/entities/lesson.dart'; // Assuming Lesson entity exists
import 'package:frontend/domain/entities/user.dart'; // Assuming User entity exists

abstract class UserProgressRepository {
  Future<UserProgress> markLessonComplete(int lessonId, int userId);
  Future<List<UserProgress>> getUserProgress(int userId);
}
