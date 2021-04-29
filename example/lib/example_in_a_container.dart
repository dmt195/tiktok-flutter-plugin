import 'package:flutter/material.dart';
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
      home: HomeWidget(colors: _colors),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    required this.colors,
  });

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 450,
            width: 300,
            child: TikTokStyleFullPageScroller(
              contentSize: colors.length,
              swipePositionThreshold: 0.2,
              // ^ the fraction of the screen needed to scroll
              swipeVelocityThreshold: 2000,
              // ^ the velocity threshold for smaller scrolls
              animationDuration: const Duration(milliseconds: 300),
              // ^ how long the animation will take
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
          ),
        ),
      ),
    );
  }
}
