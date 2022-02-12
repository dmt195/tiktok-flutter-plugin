import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/controller.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Color> _colors = <Color>[
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
    ];

    return MaterialApp(
      home: HomeWidget(
        colors: _colors,
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    required this.colors,
    this.callback,
  });

// This is a parameter to support testing in this repo
  final ScrollEventCallback? callback;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TikTokStyleFullPageScroller(
        contentSize: colors.length,
        swipePositionThreshold: 0.2,
        // ^ the fraction of the screen needed to scroll
        swipeVelocityThreshold: 2000,
        // ^ the velocity threshold for smaller scrolls
        animationDuration: const Duration(milliseconds: 300),
        // ^ how long the animation will take
        onScrollEvent: callback ?? _handleCallbackEvent,
        // ^ registering our own function to listen to page changes
        builder: (BuildContext context, int index) {
          return Container(
            color: colors[index],
            child: Center(
              child: Text(
                '$index',
                key: Key('$index-text'),
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success,
      {int? currentIndex}) {
    print(
        "Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ?? 'not given'}}");
  }
}
