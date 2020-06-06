library tiktoklikescroller;

import 'package:flutter/widgets.dart';

class TikTokStyleFullPageScroller extends StatefulWidget {
  const TikTokStyleFullPageScroller(
      {@required this.contentSize,
      @required this.builder,
      this.swipeThreshold = 0.20,
      this.swipeVelocityThreshold = 1000});

  final int contentSize;
  final IndexedWidgetBuilder builder;
  final double swipeThreshold;
  final double swipeVelocityThreshold;

  @override
  _TikTokStyleFullPageScrollerState createState() =>
      _TikTokStyleFullPageScrollerState();
}

class _TikTokStyleFullPageScrollerState
    extends State<TikTokStyleFullPageScroller>
    with SingleTickerProviderStateMixin {
  Size _screenSize;
  double _cardOffset;
  double _dragStartPosition;
  AnimationController _animationController;
  Animation<double> _animation;
  int _cardIndex;
  DragState _dragState;

  @override
  void initState() {
    _cardOffset = 0;
    _dragStartPosition = 0;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
    _cardIndex = 0;
    _dragState = DragState.idle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        if (_cardIndex > 0)
          Positioned(
            bottom: _screenSize.height - _cardOffset,
            child: SizedBox.fromSize(
                size: _screenSize,
                child: widget.builder(context, _cardIndex - 1)),
          ),
        Positioned(
          top: _cardOffset,
          child: GestureDetector(
            child: SizedBox.fromSize(
                size: _screenSize, child: widget.builder(context, _cardIndex)),
            onVerticalDragStart: (DragStartDetails details) {
              setState(() {
                _dragState = DragState.dragging;
                _dragStartPosition = details.globalPosition.dy;
              });
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                _cardOffset = details.localPosition.dy - _dragStartPosition;
              });
            },
            onVerticalDragEnd: (DragEndDetails details) {
              DragState state;
              // If the length of scroll goes beyond the point of no return
              // or if a small flick was faster than the velocity threshold
              if ((_cardOffset < -_screenSize.height * widget.swipeThreshold ||
                      details.primaryVelocity <
                          -widget.swipeVelocityThreshold) &&
                  _cardIndex < widget.contentSize - 1) {
                // build animation, set state to animate forward
                // Animate to next card
                state = DragState.animatingForward;
              } else if ((_cardOffset >
                          _screenSize.height / widget.swipeThreshold ||
                      details.primaryVelocity >
                          widget.swipeVelocityThreshold) &&
                  _cardIndex > 0) {
                // Animate to previous card
                state = DragState.animatingBackward;
              } else {
                state = DragState.animatingToCancel;
              }
              setState(() {
                _dragState = state;
              });
              _createAnimation();
            },
          ),
        ),
        if (_cardIndex < widget.contentSize - 1)
          Positioned(
            top: _screenSize.height + _cardOffset,
            child: SizedBox.fromSize(
                size: _screenSize,
                child: widget.builder(context, _cardIndex + 1),
            ),
          ),
      ],
    );
  }

  void _createAnimation() {
    double end;
    switch (_dragState) {
      case DragState.animatingForward:
        end = -_screenSize.height;
        break;
      case DragState.animatingBackward:
        end = _screenSize.height;
        break;
      case DragState.animatingToCancel:
      default:
        end = 0;
    }
    _animation = Tween<double>(begin: _cardOffset, end: end)
        .animate(_animationController)
          ..addListener(_animationListener)
          ..addStatusListener((AnimationStatus status) {
            switch (status) {
              case AnimationStatus.completed:
                // change the card index if required,
                // change the offset back to zero,
                // change the drag state back to idle
                int newCardIndex = _cardIndex;
                switch (_dragState) {
                  case DragState.animatingForward:
                    newCardIndex++;
                    break;
                  case DragState.animatingBackward:
                    newCardIndex--;
                    break;
                  case DragState.animatingToCancel:
                    //no change to card index
                    break;
                  default:
                }

                if (status != AnimationStatus.dismissed &&
                    status != AnimationStatus.forward) {
                  setState(() {
                    _cardIndex = newCardIndex;
                    _dragState = DragState.idle;
                    _cardOffset = 0;
                  });
                  _animation.removeListener(_animationListener);
                  _animationController.reset();
                }
                break;
              default:
            }
          });
    _animationController.forward();
  }

  void _animationListener() {
    setState(() {
      _cardOffset = _animation.value;
    });
  }
}

enum DragState {
  idle,
  dragging,
  animatingForward,
  animatingBackward,
  animatingToCancel,
}
