import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/screens/course_catalog_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/courses_provider.dart';
import 'package:frontend/domain/entities/course.dart'; // Import Course entity
import 'package:frontend/data/models/course_model.dart'; // Import CourseModel
import 'package:frontend/data/mappers/course_mapper.dart'; // Import CourseMapper

// Mock course data
final mockCourseModels = [
  CourseModel(
    id: 1,
    title: 'Test Course 1',
    description: 'This is a test course.',
    tier: 'free',
  ),
  CourseModel(
    id: 2,
    title: 'Test Course 2',
    description: 'This is another test course.',
    tier: 'premium',
  ),
];

// Mock provider that returns our test data
final mockCoursesProvider = FutureProvider<List<Course>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 100));
  return mockCourseModels.map((model) => CourseMapper.fromModel(model)).toList();
});

void main() {
  group('CourseCatalogScreen', () {
    testWidgets('Course catalog screen shows loading indicator', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coursesProvider.overrideWith(mockCoursesProvider),
          ],
          child: const MaterialApp(
            home: CourseCatalogScreen(),
          ),
        ),
      );

      // Initially should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // After the future resolves, should show courses
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Test Course 1'), findsOneWidget);
      expect(find.text('Test Course 2'), findsOneWidget);
    });

    testWidgets('Course catalog screen shows courses', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coursesProvider.overrideWith(mockCoursesProvider),
          ],
          child: const MaterialApp(
            home: CourseCatalogScreen(),
          ),
        ),
      );

      // Wait for the future to resolve
      await tester.pumpAndSettle();

      // Verify that courses are displayed
      expect(find.text('Test Course 1'), findsOneWidget);
      expect(find.text('This is a test course.'), findsOneWidget);
      expect(find.text('Tier: free'), findsOneWidget);

      expect(find.text('Test Course 2'), findsOneWidget);
      expect(find.text('This is another test course.'), findsOneWidget);
      expect(find.text('Tier: premium'), findsOneWidget);
    });
  });
}
