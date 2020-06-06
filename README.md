# tiktoklikescroller

A vertical fullscreen scroll implementation that snaps in place, similar to the TikTok app.

## Demo

![Example at work](v0.1.0.gif)

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Color> colors = <Color>[Colors.red, Colors.blue, Colors.yellow];

    return MaterialApp(
      home: Scaffold(
        body: TikTokStyleFullPageScroller(
          contentSize: colors.length,
          swipeThreshold: 0.2,
          // ^ the fraction of the screen needed to scroll
          swipeVelocityThreshold: 2000,
          // ^ the velocity threshold for smaller scrolls
          animationDuration: const Duration(milliseconds: 300),
          // ^ how long the animation will take
          builder: (BuildContext context, int index) {
            return Container(
                color: colors[index],
                child: Text(
                  '$index',
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              );
          },
        ),
      ),
    );
  }
}
```