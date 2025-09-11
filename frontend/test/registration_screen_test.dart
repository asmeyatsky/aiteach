import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/screens/registration_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Registration screen has correct fields', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegistrationScreen(),
        ),
      ),
    );

    // Verify that the registration screen has username, email, and password fields
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Already have an account? Login'), findsOneWidget);
  });

  testWidgets('Registration screen shows validation errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegistrationScreen(),
        ),
      ),
    );

    // Tap the register button without entering any data
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Verify that validation errors are shown
    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Registration screen validates username length', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegistrationScreen(),
        ),
      ),
    );

    // Enter a short username
    await tester.enterText(find.byType(TextField).at(0), 'ab');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.pump();

    // Tap the register button
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Verify that username validation error is shown
    expect(find.text('Username must be at least 3 characters long'), findsOneWidget);
  });

  testWidgets('Registration screen validates email format', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegistrationScreen(),
        ),
      ),
    );

    // Enter an invalid email
    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'invalid-email');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.pump();

    // Tap the register button
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Verify that email validation error is shown
    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('Registration screen validates password length', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegistrationScreen(),
        ),
      ),
    );

    // Enter a short password
    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.pump();

    // Tap the register button
    await tester.tap(find.text('Register'));
    await tester.pump();

    // Verify that password validation error is shown
    expect(find.text('Password must be at least 6 characters long'), findsOneWidget);
  });
}