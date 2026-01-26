import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/screens/playground_screen.dart';
import 'package:frontend/presentation/screens/project_list_screen.dart';
import 'package:frontend/presentation/screens/feed_screen.dart';
import 'package:frontend/presentation/screens/suggestion_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import ProviderScope
import 'package:frontend/providers/project_provider.dart'; // Import projectsProvider
import 'package:frontend/providers/feed_provider.dart'; // Import feedItemsProvider

// Mock data for ProjectListScreen
import 'mocks/mock_project_data.dart'; // Mock project data
// Mock data for FeedScreen
import 'mocks/mock_feed_data.dart'; // Mock feed data

void main() {
  group('New Feature Screens Tests', () {
    // Test Playground Screen
    testWidgets('Playground screen shows title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PlaygroundScreen(),
        ),
      );

      expect(find.text('AI Playground'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('Playground screen has chat interface', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PlaygroundScreen(),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    // Test Project List Screen
    testWidgets('Project list screen shows title and projects', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith(
              (ref) => Future.value(mockProjects),
            ),
          ],
          child: const MaterialApp(
            home: ProjectListScreen(),
          ),
        ),
      );

      expect(find.text('Project-Based Learning'), findsOneWidget);
      await tester.pumpAndSettle(); // Wait for projects to load
      expect(find.text('Project 1'), findsOneWidget);
      expect(find.text('Project 2'), findsOneWidget);
    });

    // Test Feed Screen
    testWidgets('Feed screen shows title and feed items', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            feedItemsProvider.overrideWith(
              (ref) => Future.value(mockFeedItems),
            ),
          ],
          child: const MaterialApp(
            home: FeedScreen(),
          ),
        ),
      );

      expect(find.text("What's New in AI"), findsOneWidget);
      await tester.pumpAndSettle(); // Wait for feed items to load
      expect(find.text('Feed Item 1 Title'), findsOneWidget);
      expect(find.text('Feed Item 2 Title'), findsOneWidget);
    });

    // Test Suggestion Screen
    testWidgets('Suggestion screen shows title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SuggestionScreen(),
        ),
      );

      expect(find.text('Suggest Content'), findsOneWidget);
    });

    testWidgets('Suggestion screen has form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SuggestionScreen(),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // URL and comment fields
      expect(find.byType(DropdownButtonFormField), findsOneWidget); // Track selection
      expect(find.byType(ElevatedButton), findsOneWidget); // Submit button
    });

    testWidgets('Suggestion screen validates URL field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SuggestionScreen(),
        ),
      );

      // Find and enter invalid URL
      final urlField = find.byKey(const ValueKey('resource_url_field'));
      
      await tester.enterText(urlField, 'invalid-url');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show validation error
      expect(find.text('URL must start with http:// or https://'), findsOneWidget);
    });
  });
}
