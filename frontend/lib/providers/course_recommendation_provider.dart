import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/course_recommendation_service.dart';
import 'package:frontend/domain/entities/course_recommendation.dart';

final courseRecommendationServiceProvider = Provider<CourseRecommendationService>((ref) {
  return CourseRecommendationService();
});

final recommendedCoursesProvider = FutureProvider.autoDispose.family<List<CourseRecommendation>, int>((ref, userId) async {
  final service = ref.watch(courseRecommendationServiceProvider);
  return await service.getRecommendedCourses(userId);
});