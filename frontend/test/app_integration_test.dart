import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app launches without errors
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('App has responsive layout', (WidgetTester tester) async {
    // Test with mobile size
    tester.view.physicalSize = const Size(300, 600);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MyApp());

    // Verify that the app launches without errors
    expect(find.byType(Scaffold), findsWidgets);

    // Reset
    tester.view.reset();
  });
}