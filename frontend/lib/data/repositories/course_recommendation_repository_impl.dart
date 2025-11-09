// frontend/lib/data/repositories/course_recommendation_repository_impl.dart
import 'package:frontend/data/datasources/course_recommendation_api_data_source.dart';
import 'package:frontend/data/mappers/course_recommendation_mapper.dart';
import 'package:frontend/domain/entities/course.dart'; // Assuming Course entity is used for recommendations
import 'package:frontend/domain/entities/course_recommendation.dart';
import 'package:frontend/domain/repositories/course_recommendation_repository.dart';

class CourseRecommendationRepositoryImpl implements CourseRecommendationRepository {
  final CourseRecommendationApiDataSource apiDataSource;

  CourseRecommendationRepositoryImpl(this.apiDataSource);

  @override
  Future<List<CourseRecommendation>> getRecommendedCourses(int userId) async {
    final recommendationModels = await apiDataSource.getRecommendedCourses(userId);
    return recommendationModels.map((model) => CourseRecommendationMapper.fromModel(model)).toList();
  }
}
