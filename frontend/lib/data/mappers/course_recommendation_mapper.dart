// frontend/lib/data/mappers/course_recommendation_mapper.dart
import 'package:frontend/data/models/course_recommendation_model.dart';
import 'package:frontend/domain/entities/course_recommendation.dart';

class CourseRecommendationMapper {
  static CourseRecommendation fromModel(CourseRecommendationModel model) {
    return CourseRecommendation(
      id: model.id,
      title: model.title,
      description: model.description,
      category: model.category,
      recommendedLevel: model.recommendedLevel,
      estimatedHours: model.estimatedHours,
      rating: model.rating,
      enrolledCount: model.enrolledCount,
      skillsCovered: model.skillsCovered,
    );
  }

  static CourseRecommendationModel toModel(CourseRecommendation entity) {
    return CourseRecommendationModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      recommendedLevel: entity.recommendedLevel,
      estimatedHours: entity.estimatedHours,
      rating: entity.rating,
      enrolledCount: entity.enrolledCount,
      skillsCovered: entity.skillsCovered,
    );
  }
}
