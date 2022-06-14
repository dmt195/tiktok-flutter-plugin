library tiktoklikescroller;

/// Sent as part of a [ScrollEventCallback] to track progress of swipe events
/// [FORWARD] is emitted when the user swipes up (ie the index of the array increases),
/// [BACKWARDS] is emitted when scrolled in the opposite direction.
enum ScrollDirection { FORWARD, BACKWARDS }

/// Sent as part of a [ScrollEventCallback] to track progress of swipe events
/// [SUCCESS] is emitted for a successful swipe events, [FAILED_THRESHOLD_NOT_REACHED]
/// is emitted when a drag event doesn't meet the translation of velocity requirements
/// of a swipe event. Finally, [FAILED_END_OF_LIST] is emitted when a user tries
/// to go beyond the bounds of the array (either start or end) of the list.
enum ScrollSuccess {
  SUCCESS,
  FAILED_THRESHOLD_NOT_REACHED,
  FAILED_END_OF_LIST,
}

/// The type used to encapsulate events related to scrolling
typedef void ScrollEventCallback(ScrollEvent event);

class ControllerFeedback {
  final ControllerCommandTypes command;
  final Object? data;

  ControllerFeedback(this.command, {this.data});

  @override
  String toString() {
    return "ControllerFeedback with command: $command, and ${data.toString()}";
  }
}

class ScrollEvent {
  ScrollDirection direction;
  ScrollSuccess success;
  int? pageNo;
  double? percentWhenReleased;

  ScrollEvent(this.direction, this.success, this.pageNo,
      {this.percentWhenReleased = 0.0});

  @override
  toString() {
    return "ScrollEvent: Direction: $direction, Success: $success, Page: ${pageNo ?? "Not given"}, Percent when released: $percentWhenReleased";
  }

  @override
  bool operator ==(Object other) {
    if (other is! ScrollEvent) {
      return false;
    }
    return this.direction == other.direction &&
        this.success == other.success &&
        this.pageNo == other.pageNo;
  }

  @override
  int get hashCode => super.hashCode;
}

/// Enum to track the current state of manual dragging or animation
enum DragState {
  idle,
  dragging,
  animatingForward,
  animatingBackward,
  animatingToCancel,
}

/// Enum describing commands that cam sent into the controller
enum ControllerCommandTypes { jumpToPosition, animateToPosition }
