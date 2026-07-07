import 'dart:math' as math;

import 'package:boo_mondai/lib.barrel.dart'
    show Breakpoints, PlatformService, AppTokens, MainController;
import 'package:flutter/material.dart';
import 'package:unite_keyboard_visibility/unite_keyboard_visibility.dart';

class ScaffoldHelper {
  const ScaffoldHelper({
    required this.tokens,
    required this.mediaQuery,
    required this.mainController,
    required this.appBar,
    required this.sidebar,
    required this.sidebarWidth,
    required this.bottomNavBar,
    required this.toolBar,
    required this.padding,
    required this.hideNavigation,
    required this.floatingActionButton,
    required this.preferredFloatingActionButtonHeight,
    required this.showBottomNavBar,
    required this.showAppBar,
    required this.isFloatingSideBar,
    required this.isFloatingAppBar,
    required this.haveSideBarOpenButton,
    required this.haveBottomNavBarBottomGap,
    required this.inheritMainBottomNavBarHeight,
    required this.isUserInputFocusing,
  });

  final AppTokens tokens;
  final MediaQueryData mediaQuery;
  final MainController mainController;
  final PreferredSizeWidget? appBar;
  final Widget? sidebar;
  final double sidebarWidth;
  final PreferredSizeWidget? bottomNavBar;
  final PreferredSizeWidget? toolBar;
  final EdgeInsetsGeometry? padding;
  final bool hideNavigation;
  final Widget? floatingActionButton;
  final double preferredFloatingActionButtonHeight;
  final bool showBottomNavBar;
  final bool showAppBar;
  final bool isFloatingSideBar;
  final bool isFloatingAppBar;
  final bool haveSideBarOpenButton;
  final bool haveBottomNavBarBottomGap;
  final bool inheritMainBottomNavBarHeight;
  final bool isUserInputFocusing;

  bool get shouldHaveAppBar =>
      appBar != null && showAppBar && !isFloatingAppBar;

  bool get shouldHaveFloatingAppBar =>
      appBar != null && showAppBar && isFloatingAppBar;

  bool get shouldHaveEitherAppBar =>
      shouldHaveAppBar || shouldHaveFloatingAppBar;

  bool get shouldHaveBottomNavBar {
    final isMobile = Breakpoints.isMobile(mediaQuery.size);
    return !hideNavigation &&
        isMobile &&
        bottomNavBar != null &&
        showBottomNavBar &&
        !shouldHaveToolBar;
  }

  bool get shouldHaveToolBar => toolBar != null && isUserInputFocusing;

  bool get shouldBodyHaveBottomScaffoldSafeArea =>
      (shouldHaveToolBar ||
          shouldHaveBottomNavBar ||
          shouldHaveEitherFab ||
          inheritMainBottomNavBarHeight) &&
      haveBottomNavBarBottomGap;

  double get trueBottomNavBarHeight {
    if (inheritMainBottomNavBarHeight) {
      return mainController.bottomNavBarHeight + mediaQuery.viewPadding.bottom;
    }
    if (shouldHaveBottomNavBar) {
      return bottomNavBar!.preferredSize.height + mediaQuery.viewPadding.bottom;
    }
    return 0;
  }

  double get trueToolBarHeight {
    final isKeyboardOpen = mediaQuery.viewInsets.bottom > 50;
    if (shouldHaveToolBar) {
      return toolBar!.preferredSize.height +
          (isKeyboardOpen ? 0 : mediaQuery.viewPadding.bottom);
    }
    return 0;
  }

  double get trueBottomOverlayHeight {
    if (shouldHaveToolBar) {
      return trueToolBarHeight;
    }
    return trueBottomNavBarHeight;
  }

  double get trueAppBarHeight {
    if (shouldHaveEitherAppBar) {
      return appBar!.preferredSize.height + mediaQuery.viewPadding.top;
    }
    return 0;
  }

  bool get shouldHaveSideBarButton =>
      haveSideBarOpenButton && !shouldHaveToolBar;

  EdgeInsets get scaffoldPadding {
    return PlatformService.getScaffoldPadding(tokens);
  }

  bool get shouldHaveFab => floatingActionButton != null && !shouldHaveToolBar;

  bool get shouldHaveEitherFab => shouldHaveSideBarButton || shouldHaveFab;

  double get fabBottomPadding {
    return tokens.spaceLayoutGapMd +
        (trueBottomOverlayHeight == 0
            ? mediaQuery.viewPadding.bottom
            : trueBottomOverlayHeight);
  }

  double get trueFloatingActionButtonHeight {
    if (shouldHaveEitherFab) {
      return preferredFloatingActionButtonHeight;
    }
    return 0;
  }

  double get bottomScaffoldSafeAreaHeight {
    final floatingActionButtonBottomHeight = shouldHaveEitherFab
        ? fabBottomPadding + trueFloatingActionButtonHeight
        : 0.0;

    return math.max(trueBottomOverlayHeight, floatingActionButtonBottomHeight);
  }

  bool get shouldHaveDockedSideBar {
    final isMobile = Breakpoints.isMobile(mediaQuery.size);
    return !hideNavigation &&
        !isMobile &&
        sidebar != null &&
        !isFloatingSideBar;
  }

  bool get shouldHaveFloatingSideBar {
    final isMobile = Breakpoints.isMobile(mediaQuery.size);
    return !hideNavigation &&
        sidebar != null &&
        (isFloatingSideBar || isMobile || haveSideBarOpenButton);
  }

  double get trueSideBarWidth {
    return shouldHaveDockedSideBar ? sidebarWidth : 0.0;
  }

  EdgeInsetsGeometry get contentPadding {
    return padding ?? scaffoldPadding;
  }
}
