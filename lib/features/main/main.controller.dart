import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/foundation.dart';

class MainController extends ChangeNotifier {
  bool isBottomNavBarVisible = true;
  bool isAppBarVisible = true;
  double bottomNavBarHeight = BottomNavBar.preferredHeightDefault;

  void setBottomNavBarVisible(bool value) {
    isBottomNavBarVisible = value;
    notifyListeners();
  }

  void setAppBarVisible(bool value) {
    isAppBarVisible = value;
    notifyListeners();
  }
}
