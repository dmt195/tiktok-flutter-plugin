enum ScrollDirection { FORWARD, BACKWARDS }

enum ScrollSuccess {
  SUCCESS,
  FAILED_THRESHOLD_NOT_REACHED,
  FAILED_END_OF_LIST,
}

typedef void ScrollEventCallback(
    ScrollDirection direction, ScrollSuccess success,
    {int currentIndex});

abstract class Controller {
  int getScrollPostion();
  void moveToPosition(int position);
  Future<void> animateToPosition(int position);
  void addListener(ScrollEventCallback listener);
}
