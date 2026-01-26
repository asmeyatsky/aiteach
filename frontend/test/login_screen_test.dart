import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/screens/login_screen.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'mocks/mock_auth_service.dart';
import 'mocks/mock_user_repository.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('Login screen has correct fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(MockAuthService(MockUserRepository())),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Don\'t have an account? Register'), findsOneWidget);
    });

    testWidgets('Login screen shows validation errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(MockAuthService(MockUserRepository())),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Login screen validates password length', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(MockAuthService(MockUserRepository())),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'testuser');
      await tester.enterText(find.byType(TextField).at(1), '123');
      await tester.pump();

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters long'), findsOneWidget);
    });

    testWidgets('Login successful with correct credentials', (WidgetTester tester) async {
      final mockAuthService = MockAuthService(MockUserRepository());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('Login fails with incorrect credentials', (WidgetTester tester) async {
      final mockAuthService = MockAuthService(MockUserRepository());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'wronguser');
      await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Login failed'), findsOneWidget);
    });
  });
}