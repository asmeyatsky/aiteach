// frontend/lib/domain/entities/course_recommendation.dart
import 'package:equatable/equatable.dart';
import 'package:frontend/data/models/user_proficiency_model.dart'; // Assuming ProficiencyLevel is still used

class CourseRecommendation extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final ProficiencyLevel recommendedLevel;
  final int estimatedHours;
  final double rating;
  final int enrolledCount;
  final List<String> skillsCovered;

  const CourseRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.recommendedLevel,
    required this.estimatedHours,
    required this.rating,
    required this.enrolledCount,
    required this.skillsCovered,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        recommendedLevel,
        estimatedHours,
        rating,
        enrolledCount,
        skillsCovered,
      ];
}
