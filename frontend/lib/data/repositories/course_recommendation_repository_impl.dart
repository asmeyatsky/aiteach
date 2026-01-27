// frontend/lib/data/repositories/course_recommendation_repository_impl.dart
import 'package:frontend/data/datasources/course_recommendation_api_data_source.dart';
import 'package:frontend/data/models/course_recommendation_model.dart';
import 'package:frontend/data/models/course_model.dart';
import 'package:frontend/domain/entities/course.dart';
import 'package:frontend/domain/repositories/course_recommendation_repository.dart';

class CourseRecommendationRepositoryImpl
    implements CourseRecommendationRepository {
  final CourseRecommendationApiDataSource apiDataSource;

  CourseRecommendationRepositoryImpl(this.apiDataSource);

  @override
  Future<List<Course>> getRecommendedCourses(int userId) async {
    final courseModels = await apiDataSource.getRecommendedCourses(userId);
    return courseModels.map((model) => _convertToCourse(model)).toList();
  }

  Course _convertToCourse(CourseRecommendationModel model) {
    return Course(
      id: model.id,
      title: model.title,
      description: model.description,
      tier: model.recommendedLevel.name,
      thumbnailUrl: '',
    );
  }
}
