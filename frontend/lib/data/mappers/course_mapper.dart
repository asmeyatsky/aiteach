// frontend/lib/data/mappers/course_mapper.dart
import 'package:frontend/data/models/course_model.dart';
import 'package:frontend/domain/entities/course.dart';

class CourseMapper {
  static Course fromModel(CourseModel model) {
    return Course(
      id: model.id,
      title: model.title,
      description: model.description,
      tier: model.tier,
      thumbnailUrl: model.thumbnailUrl,
      provider: model.provider,
      url: model.url,
    );
  }

  static CourseModel toModel(Course entity) {
    return CourseModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      tier: entity.tier,
      thumbnailUrl: entity.thumbnailUrl,
      provider: entity.provider,
      url: entity.url,
    );
  }
}
