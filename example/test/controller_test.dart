import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:tiktokscroller_example/example.dart';

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

  group("Testing controller callback events", () {
    late Controller controller;
    late ScrollEvent event;

    setUp(() async {
      controller = Controller()
        ..addListener((eventFired) {
          event = eventFired;
        });
    });

    testWidgets('Small drag should result in a failure event callback',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
        testingController: controller,
      )));
      final Finder labelZero = find.byKey(Key("0-text")).first;
      await dragAndSettle(tester, labelZero, 50);
      expect(event.direction, ScrollDirection.FORWARD);
      expect(event.success, ScrollSuccess.FAILED_THRESHOLD_NOT_REACHED);
      expect(event.pageNo, null);
    });

    testWidgets(
        'Big drag in wrong direction should result in an end of list failure',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
        testingController: controller,
      )));
      final Finder labelZero = find.byKey(Key("0-text")).first;
      await dragAndSettle(tester, labelZero, -5000);
      expect(
        event,
        ScrollEvent(
            ScrollDirection.BACKWARDS, ScrollSuccess.FAILED_END_OF_LIST, 0),
      );
    });

    testWidgets('Big drag should emit forward callback',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
        testingController: controller,
      )));
      final Finder labelZero = find.byKey(Key("0-text")).first;
      await dragAndSettle(tester, labelZero, 1000);
      expect(
        event,
        ScrollEvent(ScrollDirection.FORWARD, ScrollSuccess.SUCCESS, 1),
      );
    });

    testWidgets(
        'Continual drags should allow consumer to track page until the end of the list.',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: HomeWidget(
        colors: colors,
        testingController: controller,
      )));
      const double dragDistance = 2000;
      final Finder labelZero = find.byKey(Key("0-text")).first;
      await dragAndSettle(tester, labelZero, dragDistance);
      expect(
        event,
        ScrollEvent(ScrollDirection.FORWARD, ScrollSuccess.SUCCESS, 1),
      );
      final Finder labelOne = find.byKey(Key("1-text")).first;
      await dragAndSettle(tester, labelOne, dragDistance);
      expect(
        event,
        ScrollEvent(ScrollDirection.FORWARD, ScrollSuccess.SUCCESS, 2),
      );
      final Finder labelTwo = find.byKey(Key("2-text")).first;
      await dragAndSettle(tester, labelTwo, dragDistance);
      expect(
        event,
        ScrollEvent(
            ScrollDirection.FORWARD, ScrollSuccess.FAILED_END_OF_LIST, 2),
      );
    });
  });

  group("Testing jumpTo function", () {
    late Controller controller;

    setUp(() async {
      controller = Controller();
      controller.attach();
    });

    testWidgets(
        "When Jump To Index 2 is pressed then the 2nd index should be in the visible",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeWidget(
            colors: colors,
            testingController: controller,
          ),
        ),
      );

      controller.jumpToPosition(2);
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      final Finder labelTwo = find.byKey(Key("2-text"));
      expect(labelTwo, findsOneWidget);
    });
  });

  group("Testing animateTo function", () {
    late Controller controller;

    setUp(() async {
      controller = Controller();
      controller.attach();
    });

    testWidgets(
        "When Animating To Index 2 is pressed then the 2nd index should be in the visible",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeWidget(
            colors: colors,
            testingController: controller,
          ),
        ),
      );

      controller.animateToPosition(2);
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      final Finder labelTwo = find.byKey(Key("2-text"));
      expect(labelTwo, findsOneWidget);
    });
  });
}
