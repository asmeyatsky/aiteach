import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/widgets/lesson_content_view.dart';

void main() {
  testWidgets('LessonContentView displays text content', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LessonContentView(
            contentType: 'text',
            contentData: '# Hello World\n\nThis is a **markdown** text.',
          ),
        ),
      ),
    );

    // Verify that the text content is displayed (Markdown will process the text)
    expect(find.text('Hello World'), findsOneWidget);
    // The markdown text "This is a **markdown** text." will be rendered as "This is a markdown text."
    expect(find.text('This is a markdown text.'), findsOneWidget);
  });

  testWidgets('LessonContentView displays video content', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LessonContentView(
            contentType: 'video',
            contentData: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          ),
        ),
      ),
    );

    // Verify that the video content is displayed
    expect(find.text('Video Lesson'), findsOneWidget);
    expect(find.text('Watch Video'), findsOneWidget);
    expect(find.text('www.youtube.com'), findsOneWidget);
  });

  testWidgets('LessonContentView displays quiz content', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LessonContentView(
            contentType: 'quiz',
            contentData: '{"title": "Test Quiz", "questions": []}',
          ),
        ),
      ),
    );

    // Verify that the quiz content is displayed
    // The QuizWidget should display "Invalid quiz data" for empty questions
    expect(find.text('Invalid quiz data'), findsOneWidget);
  });

  testWidgets('LessonContentView handles unknown content type', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LessonContentView(
            contentType: 'unknown',
            contentData: 'Some content',
          ),
        ),
      ),
    );

    // Should fall back to text content display
    expect(find.text('Some content'), findsWidgets);
  });
}