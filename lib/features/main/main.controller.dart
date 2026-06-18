import 'package:flutter/foundation.dart';

class MainController extends ChangeNotifier {
  bool _isBottomNavbarVisibleFromScroll = true;
  int _bottomNavbarSuppressionCount = 0;

  bool get isBottomNavbarVisible =>
      _isBottomNavbarVisibleFromScroll && _bottomNavbarSuppressionCount == 0;

  void showBottomNavbar() {
    _setBottomNavbarVisibleFromScroll(true);
  }

  void hideBottomNavbar() {
    _setBottomNavbarVisibleFromScroll(false);
  }

  void pushBottomNavbarSuppression() {
    _bottomNavbarSuppressionCount += 1;
    notifyListeners();
  }

  void popBottomNavbarSuppression() {
    if (_bottomNavbarSuppressionCount == 0) return;

    _bottomNavbarSuppressionCount -= 1;
    notifyListeners();
  }

  Future<T> runWithBottomNavbarHidden<T>(Future<T> Function() action) async {
    pushBottomNavbarSuppression();
    try {
      return await action();
    } finally {
      popBottomNavbarSuppression();
    }
  }

  void _setBottomNavbarVisibleFromScroll(bool isVisible) {
    if (_isBottomNavbarVisibleFromScroll == isVisible) return;

    _isBottomNavbarVisibleFromScroll = isVisible;
    notifyListeners();
  }
}
