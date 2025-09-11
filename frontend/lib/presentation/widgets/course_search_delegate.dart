import 'package:flutter/material.dart';
import 'package:frontend/services/course_recommendation_service.dart';

class CourseSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
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
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = CourseRecommendationService.searchCourses(query);
    
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
            close(context, course.title);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = CourseRecommendationService.searchCourses(query);
    
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final course = suggestions[index];
        return ListTile(
          title: Text(course.title),
          subtitle: Text(course.description),
          onTap: () {
            query = course.title;
            showResults(context);
          },
        );
      },
    );
  }
}