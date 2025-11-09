// frontend/lib/data/mappers/lesson_mapper.dart
import 'package:frontend/data/models/lesson_model.dart';
import 'package:frontend/domain/entities/lesson.dart';

class LessonMapper {
  static Lesson fromModel(LessonModel model) {
    return Lesson(
      id: model.id,
      courseId: model.courseId,
      title: model.title,
      contentType: model.contentType,
      contentData: model.contentData,
      order: model.order,
    );
  }

  static LessonModel toModel(Lesson entity) {
    return LessonModel(
      id: entity.id,
      courseId: entity.courseId,
      title: entity.title,
      contentType: entity.contentType,
      contentData: entity.contentData,
      order: entity.order,
    );
  }
}
