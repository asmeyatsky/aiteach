import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart' as app;

void main() {
  group('App Integration Test', () {
    testWidgets('App starts and navigates to login screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that the login screen is displayed
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Don\'t have an account? Register'), findsOneWidget);
    });
  });
}
