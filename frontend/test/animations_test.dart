import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/animations/animations.dart';

void main() {
  testWidgets('FadeInAnimation fades in widget', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FadeInAnimation(
            child: Text('Fade In'),
          ),
        ),
      ),
    );

    // Initially opacity should be 0
    expect(tester.widget<FadeTransition>(
        find.byType(FadeTransition)).opacity.value, 0.0);

    // After animation completes, opacity should be 1
    await tester.pumpAndSettle();
    expect(tester.widget<FadeTransition>(
        find.byType(FadeTransition)).opacity.value, 1.0);

    // Verify text is displayed
    expect(find.text('Fade In'), findsOneWidget);
  });

  testWidgets('SlideInAnimation slides in widget', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SlideInAnimation(
            child: Text('Slide In'),
          ),
        ),
      ),
    );

    // Initially position should be offset
    final slideTransition = tester.widget<SlideTransition>(
        find.byType(SlideTransition));
    expect(slideTransition.position.value.dy, greaterThan(0.0));

    // After animation completes, position should be zero
    await tester.pumpAndSettle();
    expect(tester.widget<SlideTransition>(
        find.byType(SlideTransition)).position.value, const Offset(0, 0));

    // Verify text is displayed
    expect(find.text('Slide In'), findsOneWidget);
  });

  testWidgets('ScaleInAnimation scales in widget', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScaleInAnimation(
            child: Text('Scale In'),
          ),
        ),
      ),
    );

    // Verify text is displayed
    expect(find.text('Scale In'), findsOneWidget);
  });
}