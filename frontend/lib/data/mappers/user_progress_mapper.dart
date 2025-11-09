// frontend/lib/data/mappers/user_progress_mapper.dart
import 'package:frontend/data/models/user_progress_model.dart';
import 'package:frontend/domain/entities/user_progress.dart';
import 'package:frontend/data/mappers/lesson_mapper.dart'; // Assuming LessonMapper exists

class UserProgressMapper {
  static UserProgress fromModel(UserProgressModel model) {
    return UserProgress(
      userId: model.userId,
      lessonId: model.lessonId,
      completedAt: model.completedAt,
      lesson: model.lesson != null ? LessonMapper.fromModel(model.lesson!) : null, // Map nested Lesson if available
    );
  }

  static UserProgressModel toModel(UserProgress entity) {
    return UserProgressModel(
      userId: entity.userId,
      lessonId: entity.lessonId,
      completedAt: entity.completedAt,
      lesson: entity.lesson != null ? LessonMapper.toModel(entity.lesson!) : null, // Map nested Lesson if available
    );
  }
}
