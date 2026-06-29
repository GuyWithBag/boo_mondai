import 'package:flutter/foundation.dart';

class MainController extends ChangeNotifier {
  bool isBottomNavbarVisible = true;
  bool isAppbarVisible = true;
  double bottomNavbarHeight = 130;

  void setBottomNavbarVisible(bool value) {
    isBottomNavbarVisible = value;
    notifyListeners();
  }

  void setAppbarVisible(bool value) {
    isAppbarVisible = value;
    notifyListeners();
  }
}
