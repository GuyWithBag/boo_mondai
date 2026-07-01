import 'package:boo_mondai/lib.barrel.dart'
    show Breakpoints, PlatformService, AppTokens, MainController;
import 'package:flutter/material.dart';

class ScaffoldHelper {
  const ScaffoldHelper({
    required this.tokens,
    required this.mediaQuery,
    required this.mainController,
    required this.appBar,
    required this.sidebar,
    required this.sidebarWidth,
    required this.bottomNavBar,
    required this.padding,
    required this.hideNavigation,
    required this.floatingActionButton,
    required this.showBottomNavBar,
    required this.showAppBar,
    required this.isFloatingSideBar,
    required this.isFloatingAppBar,
    required this.haveSideBarOpenButton,
    required this.haveBottomNavBarBottomGap,
    required this.inheritMainBottomNavBarHeight,
  });

  final AppTokens tokens;
  final MediaQueryData mediaQuery;
  final MainController mainController;
  final PreferredSizeWidget? appBar;
  final Widget? sidebar;
  final double sidebarWidth;
  final PreferredSizeWidget? bottomNavBar;
  final EdgeInsetsGeometry? padding;
  final bool hideNavigation;
  final Widget? floatingActionButton;
  final bool showBottomNavBar;
  final bool showAppBar;
  final bool isFloatingSideBar;
  final bool isFloatingAppBar;
  final bool haveSideBarOpenButton;
  final bool haveBottomNavBarBottomGap;
  final bool inheritMainBottomNavBarHeight;

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
        showBottomNavBar;
  }

  bool get shouldBodyHaveBottomScaffoldSafeArea =>
      (shouldHaveBottomNavBar || inheritMainBottomNavBarHeight) &&
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

  double get trueAppBarHeight {
    if (shouldHaveEitherAppBar) {
      return appBar!.preferredSize.height + mediaQuery.viewPadding.top;
    }
    return 0;
  }

  bool get shouldHaveSideBarButton => haveSideBarOpenButton;

  EdgeInsets get scaffoldPadding {
    return PlatformService.getScaffoldPadding(tokens);
  }

  bool get shouldHaveFab => floatingActionButton != null;

  bool get shouldHaveEitherFab => shouldHaveSideBarButton || shouldHaveFab;

  double get fabBottomPadding {
    return tokens.spaceLayoutGapMd +
        (trueBottomNavBarHeight == 0
            ? mediaQuery.viewPadding.bottom
            : trueBottomNavBarHeight);
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
