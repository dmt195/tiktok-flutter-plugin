import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktoklikescroller/controller.dart';
import 'package:tiktokscroller_example/example.dart';

// helper function to reduce repeating
Future<void> dragAndSettle(
    WidgetTester tester, Finder matcher, double distance) async {
  await tester.drag(matcher, Offset(0, -distance));
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
}

void main() {
  late List<Color> colors;
  ScrollEventType? scrollEvent;
  int? pageNo;
  late ScrollEventCallback scrollListener;

  setUp(() async {
    colors = <Color>[Colors.red, Colors.blue, Colors.green];
    scrollListener = (event, {int? currentIndex}) {
      scrollEvent = event;
      pageNo = currentIndex;
    };
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
      callback: scrollListener,
    )));
    final Finder labelZero = find.text('0').first;
    await dragAndSettle(tester, labelZero, 50);
    // 2 is not generated
    final Finder labelTwo = find.text('2');
    expect(labelTwo, findsNothing);
    expect(scrollEvent, ScrollEventType.NO_SCROLL_THRESHOLD);
    expect(pageNo, null);
  });

  testWidgets('Big drag in wrong direction should result in a settle',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
      callback: scrollListener,
    )));
    final Finder labelZero = find.text('0').first;
    await dragAndSettle(tester, labelZero, -5000);
    final Finder labelTwo = find.text('2');
    // 2 is not generated yet
    expect(labelTwo, findsNothing);
    expect(scrollEvent, ScrollEventType.NO_SCROLL_START_OF_LIST);
    expect(pageNo, 0);
  });

  testWidgets('Big drag should advance to next', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
      callback: scrollListener,
    )));
    final Finder labelZero = find.text('0').first;
    await dragAndSettle(tester, labelZero, 1000);
    // 1 is current, 2 is produced (below the fold)
    final Finder labelTwo = find.text('2');
    expect(labelTwo, findsOneWidget);
    expect(scrollEvent, ScrollEventType.SCROLLED_FORWARD);
    expect(pageNo, 1);
  });

  testWidgets(
      'Continual drags should advance to next until end of array. We Shouldnt get to index 3.',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HomeWidget(
      colors: colors,
      callback: scrollListener,
    )));
    const double dragDistance = 2000;
    final Finder labelZero = find.text('0').first;
    await dragAndSettle(tester, labelZero, dragDistance);
    expect(pageNo, 1);
    final Finder labelOne = find.text('1').first;
    await dragAndSettle(tester, labelOne, dragDistance);
    expect(pageNo, 2);
    expect(scrollEvent, ScrollEventType.SCROLLED_FORWARD);
    final Finder labelTwo = find.text('2').first;
    await dragAndSettle(tester, labelTwo, dragDistance);
    expect(pageNo, 2);
    // should not drag further than 2, and 3 is not generated below the fold
    expect(find.text('3'), findsNothing);
    // 0 is no longer in the widget tree
    expect(find.text('0'), findsNothing);
    // Callback should inform us that we've reached the end of the list
    expect(scrollEvent, ScrollEventType.NO_SCROLL_END_OF_LIST);
  });
}
