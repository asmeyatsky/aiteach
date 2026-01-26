// frontend/lib/data/repositories/course_recommendation_repository_impl.dart
import 'package:frontend/data/datasources/course_recommendation_api_data_source.dart';
import 'package:frontend/data/mappers/course_mapper.dart';
import 'package:frontend/domain/entities/course.dart';
import 'package:frontend/domain/repositories/course_recommendation_repository.dart';

class CourseRecommendationRepositoryImpl implements CourseRecommendationRepository {
  final CourseRecommendationApiDataSource apiDataSource;

  CourseRecommendationRepositoryImpl(this.apiDataSource);

  @override
  Future<List<Course>> getRecommendedCourses(int userId) async {
    final courseModels = await apiDataSource.getRecommendedCourses(userId);
    return courseModels.map((model) => CourseMapper.fromModel(model)).toList();
  }
}
