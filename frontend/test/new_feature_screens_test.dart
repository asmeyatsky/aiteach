import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/screens/playground_screen.dart';
import 'package:frontend/presentation/screens/project_list_screen.dart';
import 'package:frontend/presentation/screens/feed_screen.dart';
import 'package:frontend/presentation/screens/suggestion_screen.dart';

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
    testWidgets('Project list screen shows title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProjectListScreen(),
        ),
      );

      expect(find.text('Project-Based Learning'), findsOneWidget);
    });

    testWidgets('Project list screen has refresh indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProjectListScreen(),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    // Test Feed Screen
    testWidgets('Feed screen shows title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: const FeedScreen(),
        ),
      );

      expect(find.text("What's New in AI"), findsOneWidget);
    });

    testWidgets('Feed screen has list view', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: const FeedScreen(),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    // Test Suggestion Screen
    testWidgets('Suggestion screen shows title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: const SuggestionScreen(),
        ),
      );

      expect(find.text('Suggest Content'), findsOneWidget);
    });

    testWidgets('Suggestion screen has form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: const SuggestionScreen(),
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
          home: const SuggestionScreen(),
        ),
      );

      // Find and enter invalid URL
      final urlField = find.byWidgetPredicate(
        (widget) => widget is TextFormField && widget.decoration?.labelText == 'Resource URL',
      );
      
      await tester.enterText(urlField, 'invalid-url');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show validation error
      expect(find.text('URL must start with http:// or https://'), findsOneWidget);
    });
  });
}