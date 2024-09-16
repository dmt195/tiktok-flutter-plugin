library tiktoklikescroller;

import 'dart:async';

import 'package:tiktoklikescroller/types.dart';

/// Allows a consumer to control the list position and track current page
/// and any emitted events through a [ScrollEventCallback].
/// Track page and scroll events without further configuration. For control
/// of the Scroller, use the [attach] method.
class Controller {
  List<ScrollEventCallback> _listeners = [];
  late int _page;
  StreamController<ControllerFeedback>? feedback;

  Controller({
    int? page,
  }) : _page = page ?? 0;

  /// Returns the scroll position as tracked by the controller
  int getScrollPosition() {
    return _page;
  }

  /// Command the list to switch to the given [position] in a synchronous and
  /// immediate manner. There will be no animation. To animate, use
  /// [animateToPosition] instead.
  void jumpToPosition(int position) {
    feedback?.add(ControllerFeedback(ControllerCommandTypes.jumpToPosition,
        data: position));
  }

  /// Command the list to move to the given [position] in an animated manner.
  /// To ignore animation, use [jumpToPosition] instead
  Future<void> animateToPosition(int position) async {
    feedback?.add(ControllerFeedback(ControllerCommandTypes.animateToPosition,
        data: position));
  }

  /// Called to provide a stream of [ControllerFeedback] events
  /// into the [TikTokStyleFullPageScroller] such as [jumpToPosition]
  /// and [animateToPosition] along with their associated data..
  Stream<ControllerFeedback>? attach() {
    feedback = StreamController.broadcast(onListen: () {
      print("Something is listening to the stream of feedback events");
    }, onCancel: () {
      print("onCancel has been called");
    });
    return feedback?.stream;
  }

  /// Allows a consumer to listen to events by registering a [ScrollEventCallback]
  /// to the controller. Remeber to use [disposeListeners] when disposing parent
  /// widgets
  void addListener(ScrollEventCallback listener) {
    _listeners.add(listener);
  }

  /// Send [ScrollEvent] notifications to all registered listeners
  void notifyListeners(ScrollEvent event) {
    if (event.pageNo != null) {
      _page = event.pageNo!;
    }
    _listeners.forEach((listener) {
      listener.call(event);
    });
  }

  /// Remove all listeners to ensure there are no memory leaks.
  void disposeListeners() {
    _listeners = [];
  }
}
