// frontend/lib/domain/entities/lesson.dart
import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final int id;
  final int courseId;
  final String title;
  final String contentType;
  final String contentData;
  final int order;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.contentType,
    required this.contentData,
    required this.order,
  });

  @override
  List<Object?> get props => [id, courseId, title, contentType, contentData, order];
}
