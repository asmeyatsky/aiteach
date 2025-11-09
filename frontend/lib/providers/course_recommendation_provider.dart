// frontend/lib/providers/course_recommendation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/course_recommendation.dart';
import 'package:frontend/data/datasources/course_recommendation_api_data_source.dart';
import 'package:frontend/data/repositories/course_recommendation_repository_impl.dart';
import 'package:frontend/providers/auth_provider.dart'; // To get Dio instance

final courseRecommendationApiDataSourceProvider = Provider<CourseRecommendationApiDataSource>((ref) {
  return CourseRecommendationApiDataSource(ref.read(dioProvider));
});

final courseRecommendationRepositoryProvider = Provider<CourseRecommendationRepositoryImpl>((ref) {
  return CourseRecommendationRepositoryImpl(ref.read(courseRecommendationApiDataSourceProvider));
});

final recommendedCoursesProvider = FutureProvider.family<List<CourseRecommendation>, int>((ref, userId) async {
  final repository = ref.read(courseRecommendationRepositoryProvider);
  return repository.getRecommendedCourses(userId);
});
