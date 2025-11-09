// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseRecommendationModel _$CourseRecommendationModelFromJson(
  Map<String, dynamic> json,
) => CourseRecommendationModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  recommendedLevel: const ProficiencyLevelConverter().fromJson(
    json['recommendedLevel'] as String,
  ),
  estimatedHours: (json['estimatedHours'] as num).toInt(),
  rating: (json['rating'] as num).toDouble(),
  enrolledCount: (json['enrolledCount'] as num).toInt(),
  skillsCovered: (json['skillsCovered'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CourseRecommendationModelToJson(
  CourseRecommendationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'recommendedLevel': const ProficiencyLevelConverter().toJson(
    instance.recommendedLevel,
  ),
  'estimatedHours': instance.estimatedHours,
  'rating': instance.rating,
  'enrolledCount': instance.enrolledCount,
  'skillsCovered': instance.skillsCovered,
};
