// frontend/lib/domain/repositories/course_recommendation_repository.dart
import 'package:frontend/domain/entities/course.dart';

abstract class CourseRecommendationRepository {
  Future<List<Course>> getRecommendedCourses(int userId);
}
