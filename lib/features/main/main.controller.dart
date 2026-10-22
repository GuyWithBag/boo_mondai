import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:signals_hooks/signals_hooks.dart';

class MainController {
  final isBottomNavBarVisible = signal(true);
  final isAppBarVisible = signal(true);
  final bottomNavBarHeight = signal(BottomNavBar.preferredHeightDefault);

  static final instance = MainController();
}
