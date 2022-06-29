import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = <Color>[
      Colors.red,
      Colors.blue,
      Colors.green,
    ];

    return MaterialApp(
      home: HomeWidget(
        colors: colors,
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key? key,
    required this.colors,
    this.testingController,
  }) : super(key: key);

  // This is a parameter to support testing in this repo
  final Controller? testingController;
  final List<Color> colors;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Controller controller;

  @override
  initState() {
    controller = widget.testingController ?? Controller()
      ..addListener((event) {
        _handleCallbackEvent(event.direction, event.success);
      });

    // controller.jumpToPosition(4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TikTokStyleFullPageScroller(
        contentSize: widget.colors.length,
        swipePositionThreshold: 0.2,
        // ^ the fraction of the screen needed to scroll
        swipeVelocityThreshold: 2000,
        // ^ the velocity threshold for smaller scrolls
        animationDuration: const Duration(milliseconds: 400),
        // ^ how long the animation will take
        controller: controller,
        // ^ registering our own function to listen to page changes
        builder: (BuildContext context, int index) {
          return Container(
            color: widget.colors[index],
            child: Stack(children: [
              Center(
                child: Text(
                  '$index',
                  key: Key('$index-text'),
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  color: Colors.white.withAlpha(125),
                  child: Column(
                    children: [
                      const Text(
                          "--- Buttons For Testing Controller Functions ---"),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text("Jump To:"),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...Iterable<int>.generate(widget.colors.length)
                                .toList()
                                .map(
                                  (e) => MaterialButton(
                                    color: Colors.white.withAlpha(125),
                                    child: Text(
                                      "$e",
                                      key: Key('$e-jump'),
                                    ),
                                    onPressed: () =>
                                        controller.jumpToPosition(e),
                                  ),
                                )
                                .toList(),
                          ]),
                      const Text("Animate To:"),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...Iterable<int>.generate(widget.colors.length)
                                .toList()
                                .map(
                                  (e) => MaterialButton(
                                    color: Colors.white.withAlpha(125),
                                    child: Text(
                                      "$e",
                                      key: Key('$e-animate'),
                                    ),
                                    onPressed: () =>
                                        controller.animateToPosition(e),
                                  ),
                                )
                                .toList(),
                          ]),
                    ],
                  ),
                ),
              ),
            ]),
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
