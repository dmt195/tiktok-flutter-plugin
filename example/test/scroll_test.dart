import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktokscroller_example/example.dart';

void main() {
  List<Color> colors;

  setUp(() async {
    colors = <Color>[Colors.red, Colors.blue, Colors.green];
  });

  testWidgets('Widget has label of 0 on 1st page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
    )));
    final Finder labelZero = find.text('0');
    expect(labelZero, findsOneWidget);
  });

  testWidgets('Widget has label of 1 on 2nd page (below fold)',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
    )));
    final Finder labelZero = find.text('1');
    expect(labelZero, findsOneWidget);
  });

  testWidgets('Widget with of 2 not yet built', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
    )));
    final Finder labelZero = find.text('2');
    expect(labelZero, findsNothing);
  });

  testWidgets('Small drag should result in a settle',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
    )));
    final Finder labelZero = find.text('0').first;
    await tester.drag(labelZero, const Offset(0, -50));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    // 2 is not generated
    final Finder labelTwo = find.text('2');
    expect(labelTwo, findsNothing);
  });

  testWidgets('Big drag in wrong direction should result in a settle',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
    )));
    final Finder labelZero = find.text('0').first;
    await tester.drag(labelZero, const Offset(0, 5000));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    final Finder labelTwo = find.text('2');
    // 2 is not generated yet
    expect(labelTwo, findsNothing);
  });

  testWidgets('Big drag should advance to next', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
    )));
    final Finder labelZero = find.text('0').first;
    await tester.drag(labelZero, const Offset(0, -1000));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    // 2 is produced (below the fold)
    final Finder labelTwo = find.text('2');
    expect(labelTwo, findsOneWidget);
  });

  testWidgets(
      'Continual drags should advance to next until end of array. We Shouldnt get to index 3.',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
    )));
    const double dragDistance = 2000;
    final Finder labelZero = find.text('0').first;
    await tester.drag(labelZero, const Offset(0, -dragDistance));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    final Finder labelOne = find.text('1').first;
    await tester.drag(labelOne, const Offset(0, -dragDistance));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    final Finder labelTwo = find.text('2').first;
    await tester.drag(labelTwo, const Offset(0, -dragDistance));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    // should not drag further than 2, and 3 is not generated below the fold
    expect(find.text('3'), findsNothing);
    // 0 is no longer in the widget tree
    expect(find.text('0'), findsNothing);
  });
}
