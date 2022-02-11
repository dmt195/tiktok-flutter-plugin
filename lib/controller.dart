enum ScrollEventType {
  SCROLLED_FORWARD,
  SCROLLED_BACKWARDS,
  NO_SCROLL_THRESHOLD,
  NO_SCROLL_END_OF_LIST,
  NO_SCROLL_START_OF_LIST,
}

typedef void ScrollEventCallback(ScrollEventType type, {int currentIndex});

abstract class Controller {
  int getScrollPostion();
  void moveToPosition(int position);
  Future<void> animateToPosition(int position);
  void addListener(ScrollEventCallback listener);
}
