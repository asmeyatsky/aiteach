// frontend/lib/domain/entities/user_progress.dart
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/lesson.dart'; // Assuming Lesson entity exists

class UserProgress extends Equatable {
  final int userId;
  final int lessonId;
  final DateTime completedAt;
  final Lesson? lesson; // Assuming lesson might be loaded with user progress

  const UserProgress({
    required this.userId,
    required this.lessonId,
    required this.completedAt,
    this.lesson,
  });

  @override
  List<Object?> get props => [userId, lessonId, completedAt, lesson];
}
