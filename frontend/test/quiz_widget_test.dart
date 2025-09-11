import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/widgets/quiz_widget.dart';

void main() {
  final validQuizJson = '''
  {
    "title": "Sample Quiz",
    "questions": [
      {
        "question": "What is 2+2?",
        "options": ["3", "4", "5", "6"],
        "correctAnswerIndex": 1
      },
      {
        "question": "What is the capital of France?",
        "options": ["London", "Berlin", "Paris", "Madrid"],
        "correctAnswerIndex": 2
      }
    ]
  }
  ''';

  final invalidQuizJson = 'invalid json';

  testWidgets('QuizWidget displays quiz title and questions', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuizWidget(quizDataJson: validQuizJson),
        ),
      ),
    );

    // Verify that the quiz title is displayed
    expect(find.text('Sample Quiz'), findsOneWidget);

    // Verify that the first question is displayed
    expect(find.text('What is 2+2?'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('QuizWidget handles invalid JSON', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuizWidget(quizDataJson: invalidQuizJson),
        ),
      ),
    );

    // Should show invalid quiz data message
    expect(find.text('Invalid quiz data'), findsOneWidget);
  });

  testWidgets('QuizWidget handles empty questions', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: QuizWidget(quizDataJson: '{"title": "Empty Quiz", "questions": []}'),
        ),
      ),
    );

    // Should show invalid quiz data message
    expect(find.text('Invalid quiz data'), findsOneWidget);
  });

  testWidgets('QuizWidget allows selecting options', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuizWidget(quizDataJson: validQuizJson),
        ),
      ),
    );

    // Select the first option (incorrect)
    await tester.tap(find.text('3'));
    await tester.pump();

    // Verify that the result is shown
    expect(find.text('Incorrect. The correct answer is B.'), findsOneWidget);
  });
}