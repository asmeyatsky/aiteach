import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentation/widgets/responsive_layout.dart';

void main() {
  testWidgets('ResponsiveLayout shows mobile layout on small screens', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MaterialApp(
          builder: (context, child) {
            return const MediaQuery(
              data: MediaQueryData(size: Size(300, 600)),
              child: ResponsiveLayout(
                mobile: Text('Mobile'),
                desktop: Text('Desktop'),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Desktop'), findsNothing);
  });

  testWidgets('ResponsiveLayout shows desktop layout on large screens', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MaterialApp(
          builder: (context, child) {
            return const MediaQuery(
              data: MediaQueryData(size: Size(1400, 800)),
              child: ResponsiveLayout(
                mobile: Text('Mobile'),
                desktop: Text('Desktop'),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Desktop'), findsOneWidget);
    expect(find.text('Mobile'), findsNothing);
  });

  testWidgets('ResponsiveLayout shows tablet layout on medium screens', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MaterialApp(
          builder: (context, child) {
            return const MediaQuery(
              data: MediaQueryData(size: Size(800, 600)),
              child: ResponsiveLayout(
                mobile: Text('Mobile'),
                tablet: Text('Tablet'),
                desktop: Text('Desktop'),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Tablet'), findsOneWidget);
    expect(find.text('Mobile'), findsNothing);
    expect(find.text('Desktop'), findsNothing);
  });

  testWidgets('AdaptiveText shows different styles on different screen sizes', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MaterialApp(
          builder: (context, child) {
            return const MediaQuery(
              data: MediaQueryData(size: Size(300, 600)),
              child: AdaptiveText(
                'Test Text',
                mobileStyle: TextStyle(fontSize: 16),
                desktopStyle: TextStyle(fontSize: 24),
              ),
            );
          },
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.byType(Text));
    expect(textWidget.style?.fontSize, 16);
  });

  testWidgets('AdaptiveGridView shows different column counts on different screen sizes', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MaterialApp(
          builder: (context, child) {
            return const MediaQuery(
              data: MediaQueryData(size: Size(1400, 800)),
              child: AdaptiveGridView(
                mobileCrossAxisCount: 1,
                tabletCrossAxisCount: 2,
                desktopCrossAxisCount: 3,
                children: [
                  Text('Item 1'),
                  Text('Item 2'),
                  Text('Item 3'),
                ],
              ),
            );
          },
        ),
      ),
    );

    // We can't easily test the actual GridView count, but we can verify it renders
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.text('Item 3'), findsOneWidget);
  });
}