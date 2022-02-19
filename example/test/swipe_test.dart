import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktokscroller_example/example.dart';

// helper function to reduce repeating
Future<void> dragAndSettle(
    WidgetTester tester, Finder matcher, double distance) async {
  await tester.drag(
    matcher,
    Offset(0, -distance),
  );
  await tester.pumpAndSettle(const Duration(milliseconds: 10000));
  return;
}

void main() {
  final colors = <Color>[Colors.red, Colors.blue, Colors.green];

  group("Widget Scrolling tests", () {
    testWidgets('Widget has label of 0 on 1st page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
      )));
      final Finder labelZero = find.byKey(Key("0-text"));
      expect(labelZero, findsOneWidget);
    });

    testWidgets('Widget has label of 1 on 2nd page (below fold)',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
      )));
      final Finder labelZero = find.byKey(Key("1-text"));
      expect(labelZero, findsOneWidget);
    });

    testWidgets('Widget with of 2 not yet built', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
      )));
      final Finder labelZero = find.byKey(Key("2-text"));
      expect(labelZero, findsNothing);
    });

    testWidgets('Small drag should result in a settle',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
      )));
      final Finder labelZero = find.byKey(Key("0-text")).first;
      await dragAndSettle(tester, labelZero, 50);
      // 2 is not generated
      final Finder labelTwo = find.byKey(Key("2-text"));
      expect(labelTwo, findsNothing);
    });

    testWidgets('Big drag in wrong direction should result in a settle',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
      )));
      final Finder labelZero = find.byKey(Key("0-text")).first;
      await dragAndSettle(tester, labelZero, -5000);
      final Finder labelTwo = find.byKey(Key("2-text"));
      // 2 is not generated yet
      expect(labelTwo, findsNothing);
    });

    testWidgets('Big drag should advance to next', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
      )));
      final Finder labelZero = find.byKey(Key("0-text")).first;
      await dragAndSettle(tester, labelZero, 1000);
      // 1 is current, 2 is produced (below the fold)
      final Finder labelTwo = find.byKey(Key("2-text"));
      expect(labelTwo, findsOneWidget);
    });

    testWidgets(
        'Continual drags should advance to next until end of array. We Shouldnt get to index 3.',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
      )));
      const double dragDistance = 1000;
      final Finder labelZero = find.byKey(Key("0-text"));
      await dragAndSettle(tester, labelZero, dragDistance);
      final Finder labelOne = find.byKey(Key("1-text"));
      await dragAndSettle(tester, labelOne, dragDistance);
      final Finder labelTwo = find.byKey(Key("2-text"));
      await dragAndSettle(tester, labelTwo, dragDistance);
      expect(find.byKey(Key("3-text")), findsNothing);
      // 0 is no longer in the widget tree
      expect(find.byKey(Key("0-text")), findsNothing);
    });
  });
}
