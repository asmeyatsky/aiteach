import 'package:flutter/material.dart';
import 'package:frontend/services/course_recommendation_service.dart';
import 'package:frontend/domain/entities/course_recommendation.dart';
import 'package:frontend/domain/value_objects/proficiency_level.dart';

class CourseSearchDelegate extends SearchDelegate<CourseRecommendation> {
  final CourseRecommendationService _courseRecommendationService = CourseRecommendationService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, CourseRecommendation(id: 0, title: '', description: '', category: '', recommendedLevel: ProficiencyLevel.beginner, estimatedHours: 0, rating: 0, enrolledCount: 0, skillsCovered: [])); // Return a default empty object
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _courseRecommendationService.searchCourses(query);
    
    if (results.isEmpty) {
      return const Center(
        child: Text('No courses found matching your search.'),
      );
    }
    
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final course = results[index];
        return ListTile(
          title: Text(course.title),
          subtitle: Text(course.description),
          onTap: () {
            close(context, course);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _courseRecommendationService.searchCourses(query);
    
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final course = suggestions[index];
        return ListTile(
          title: Text(course.title),
          subtitle: Text(course.description),
          onTap: () {
            query = course.title;
            // You might want to call showResults(context) here if you want to show the results instantly
            // For now, let's just close with the selected suggestion
            close(context, course);
          },
        );
      },
    );
  }
}