// frontend/lib/services/course_recommendation_service.dart
import 'package:frontend/domain/entities/course_recommendation.dart';
import 'package:frontend/domain/value_objects/proficiency_level.dart';

class CourseRecommendationService {
  // This is a placeholder service that would connect to the backend API
  // In a real implementation, this would make API calls to get course recommendations
  final List<CourseRecommendation> _mockCourses = [
    CourseRecommendation(
      id: 1,
      title: 'Introduction to AI',
      description: 'Learn the basics of AI.',
      category: 'Foundations',
      recommendedLevel: ProficiencyLevel.beginner,
      estimatedHours: 10,
      rating: 4.5,
      enrolledCount: 1000,
      skillsCovered: ['AI Concepts', 'Machine Learning Basics'],
    ),
    CourseRecommendation(
      id: 2,
      title: 'Python for ML',
      description: 'Master Python for Machine Learning.',
      category: 'Programming',
      recommendedLevel: ProficiencyLevel.intermediate,
      estimatedHours: 20,
      rating: 4.7,
      enrolledCount: 1500,
      skillsCovered: ['Python', 'Pandas', 'Scikit-learn'],
    ),
  ];

  Future<List<CourseRecommendation>> getRecommendedCourses(int userId) async {
    // Placeholder implementation
    return _mockCourses;
  }

  List<CourseRecommendation> searchCourses(String query) {
    if (query.isEmpty) {
      return [];
    }
    final lowerCaseQuery = query.toLowerCase();
    return _mockCourses.where((course) {
      return course.title.toLowerCase().contains(lowerCaseQuery) ||
             course.description.toLowerCase().contains(lowerCaseQuery) ||
             course.category.toLowerCase().contains(lowerCaseQuery) ||
             course.skillsCovered.any((skill) => skill.toLowerCase().contains(lowerCaseQuery));
    }).toList();
  }
}