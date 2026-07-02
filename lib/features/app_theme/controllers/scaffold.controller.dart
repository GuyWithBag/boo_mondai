import 'package:boo_mondai/lib.barrel.dart' show Controller;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;
import 'package:unite_keyboard_visibility/unite_keyboard_visibility.dart'
    show KeyboardVisibilityStatus, UniteKeyboardVisibility;

ScaffoldController useScaffoldController({
  bool hideNavigation = false,
  bool showBottomNavBar = true,
  bool showAppBar = true,
  bool isFloatingSideBar = false,
  bool isBottomNavBarVisible = true,
  bool isEitherAppBarVisible = true,
  bool isSideBarVisible = false,
  bool isEitherFabVisible = true,
  bool isUserInputFocusing = false,
}) {
  final controller = useMemoized(
    () => ScaffoldController(
      hideNavigation: hideNavigation,
      showBottomNavBar: showBottomNavBar,
      showAppBar: showAppBar,
      isFloatingSideBar: isFloatingSideBar,
      isBottomNavBarVisible: isBottomNavBarVisible,
      isEitherAppBarVisible: isEitherAppBarVisible,
      isSideBarVisible: isSideBarVisible,
      isEitherFabVisible: isEitherFabVisible,
      isUserInputFocusing: isUserInputFocusing,
    ),
  );
  controller.updateConfig(
    hideNavigation: hideNavigation,
    showBottomNavBar: showBottomNavBar,
    showAppBar: showAppBar,
    isFloatingSideBar: isFloatingSideBar,
  );
  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}

class ScaffoldController extends Controller {
  ScaffoldController({
    bool hideNavigation = false,
    bool showBottomNavBar = true,
    bool showAppBar = true,
    bool isFloatingSideBar = false,
    bool isBottomNavBarVisible = true,
    bool isEitherAppBarVisible = true,
    bool isSideBarVisible = false,
    bool isEitherFabVisible = true,
    bool isUserInputFocusing = false,
  }) : _hideNavigation = hideNavigation,
       _showBottomNavBar = showBottomNavBar,
       _showAppBar = showAppBar,
       _isFloatingSideBar = isFloatingSideBar,
       _isBottomNavBarVisible = isBottomNavBarVisible,
       _isEitherAppBarVisible = isEitherAppBarVisible,
       _isSideBarVisible = isSideBarVisible,
       _isEitherFabVisible = isEitherFabVisible,
       _isUserInputFocusing = isUserInputFocusing;

  bool _hideNavigation;
  bool _showBottomNavBar;
  bool _showAppBar;
  bool _isFloatingSideBar;
  bool _isBottomNavBarVisible;
  bool _isEitherAppBarVisible;
  bool _isSideBarVisible;
  bool _isEitherFabVisible;
  bool _isUserInputFocusing;

  bool get hideNavigation => _hideNavigation;
  bool get showBottomNavBar => _showBottomNavBar;
  bool get showAppBar => _showAppBar;
  bool get isFloatingSideBar => _isFloatingSideBar;
  bool get isBottomNavBarVisible => _isBottomNavBarVisible;
  bool get isEitherAppBarVisible => _isEitherAppBarVisible;
  bool get isSideBarVisible => _isSideBarVisible;
  bool get isEitherFabVisible => _isEitherFabVisible;
  bool get isUserInputFocusing => _isUserInputFocusing;

  void updateConfig({
    required bool hideNavigation,
    required bool showBottomNavBar,
    required bool showAppBar,
    required bool isFloatingSideBar,
  }) {
    _hideNavigation = hideNavigation;
    _showBottomNavBar = showBottomNavBar;
    _showAppBar = showAppBar;
    _isFloatingSideBar = isFloatingSideBar;
  }

  set isBottomNavBarVisible(bool value) {
    if (_isBottomNavBarVisible == value) return;
    _isBottomNavBarVisible = value;
    notifyListeners();
  }

  set isEitherAppBarVisible(bool value) {
    if (_isEitherAppBarVisible == value) return;
    _isEitherAppBarVisible = value;
    notifyListeners();
  }

  set isSideBarVisible(bool value) {
    if (_isSideBarVisible == value) return;
    _isSideBarVisible = value;
    notifyListeners();
  }

  set isEitherFabVisible(bool value) {
    if (_isEitherFabVisible == value) return;
    _isEitherFabVisible = value;
    notifyListeners();
  }

  set isUserInputFocusing(bool value) {
    if (_isUserInputFocusing == value) return;
    _isUserInputFocusing = value;
    notifyListeners();
  }

  void toggleSideBarVisibility() {
    isSideBarVisible = !isSideBarVisible;
  }

  bool get isKeyboardVisible =>
      UniteKeyboardVisibility.instance.value == KeyboardVisibilityStatus.open;

  bool handleScrollNotification({
    required ScrollNotification notification,
    required bool hideBottomNavigationBarOnScroll,
    required bool hideAppBarOnScroll,
  }) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification.metrics.pixels <= 0) {
      if (hideBottomNavigationBarOnScroll) isBottomNavBarVisible = true;
      if (hideAppBarOnScroll) isEitherAppBarVisible = true;
      return false;
    }

    final direction = switch (notification) {
      UserScrollNotification(:final direction) => direction,
      _ => ScrollDirection.idle,
    };

    if (direction == ScrollDirection.idle) return false;

    if (hideBottomNavigationBarOnScroll) {
      isBottomNavBarVisible = direction == ScrollDirection.forward;
    }
    if (hideAppBarOnScroll) {
      isEitherAppBarVisible = direction == ScrollDirection.forward;
    }
    return false;
  }
}
