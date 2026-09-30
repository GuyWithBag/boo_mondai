import 'dart:math' as math;

import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Breakpoints, MainController, PlatformService;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:signals/signals_flutter.dart';
import 'package:unite_keyboard_visibility/unite_keyboard_visibility.dart'
    show KeyboardVisibilityStatus, UniteKeyboardVisibility;

class ScaffoldController {
  ScaffoldController({
    required this.tokens,
    required this.mediaQuery,
    required this.mainController,
    required this.appBar,
    required this.sidebar,
    required this.sidebarWidth,
    required this.bottomNavBar,
    required this.toolBar,
    required this.padding,
    required bool hideNavigation,
    required this.floatingActionButton,
    required this.preferredFloatingActionButtonHeight,
    required this.hideAppBarOnScroll,
    required this.hideBottomNavigationBarOnScroll,
    required this.hideFloatingActionButtonOnScroll,
    required this.isFloatingAppBar,
    required this.haveSideBarOpenButton,
    required this.haveBottomNavBarBottomGap,
    required this.inheritMainBottomNavBarHeight,
    required this.resizeBodyForKeyboard,
    required this.scrollable,
    required this.showUnfocusButton,
    required this.showViewPaddingBottom,
    required this.showViewPaddingTop,
    required this.centeredConstraint,
    required this.centeredBody,
    required this.shouldConstrainWidth,
    required this.safeArea,
    required this.maxWidth,
    required this.onRefresh,
    required this.refreshBuilder,
    required this.scrollStartAtTheBottom,
    required this.scrollController,
    required this.initialShowBottomNavBar,
    required this.initialShowAppBar,
    required this.initialIsFloatingSideBar,
    required this.initialFloatingSideBarInitiallyOpen,
  }) {
    showBottomNavBar.value = initialShowBottomNavBar;
    showAppBar.value = initialShowAppBar;
    hideNavigationSignal.value = hideNavigation;
    isFloatingSideBarSignal.value = initialIsFloatingSideBar;
    isSideBarVisible.value = initialFloatingSideBarInitiallyOpen;
    initializeComputedSignals();
  }

  final AppTokens tokens;
  final MediaQueryData mediaQuery;
  final MainController mainController;
  final PreferredSizeWidget? appBar;
  final Widget? sidebar;
  final double sidebarWidth;
  final PreferredSizeWidget? bottomNavBar;
  final PreferredSizeWidget? toolBar;
  final EdgeInsetsGeometry? padding;
  final Widget? floatingActionButton;
  final double preferredFloatingActionButtonHeight;
  final bool hideAppBarOnScroll;
  final bool hideBottomNavigationBarOnScroll;
  final bool hideFloatingActionButtonOnScroll;
  final bool isFloatingAppBar;
  final bool haveSideBarOpenButton;
  final bool haveBottomNavBarBottomGap;
  final bool inheritMainBottomNavBarHeight;
  final bool resizeBodyForKeyboard;
  final bool scrollable;
  final bool showUnfocusButton;
  final bool showViewPaddingBottom;
  final bool showViewPaddingTop;
  final bool centeredConstraint;
  final bool centeredBody;
  final bool shouldConstrainWidth;
  final bool safeArea;
  final double? maxWidth;
  final RefreshCallback? onRefresh;
  final ScaffoldRefreshBuilder? refreshBuilder;
  final bool scrollStartAtTheBottom;
  final ScrollController? scrollController;
  final bool initialShowBottomNavBar;
  final bool initialShowAppBar;
  final bool initialIsFloatingSideBar;
  final bool initialFloatingSideBarInitiallyOpen;

  final hideNavigationSignal = signal(false);
  final showBottomNavBar = signal(true);
  final showAppBar = signal(true);
  final isFloatingSideBarSignal = signal(false);
  final isBottomNavBarVisible = signal(true);
  final isEitherAppBarVisible = signal(true);
  final isSideBarVisible = signal(false);
  final isEitherFabVisible = signal(true);
  final isUserInputFocusing = signal(false);
  final scrollLockKeys = signal<Set<Object>>({});
  late final ScaffoldScrollLockSetter setScrollLockedCallback = setScrollLocked;

  bool isDisposed = false;

  late final Computed<bool> shouldHaveAppBar;
  late final Computed<bool> shouldHaveFloatingAppBar;
  late final Computed<bool> shouldHaveEitherAppBar;
  late final Computed<bool> shouldHaveBottomNavBar;
  late final Computed<bool> shouldHaveToolBar;
  late final Computed<bool> shouldInheritMainBottomNavBarHeight;
  late final Computed<double> trueBottomNavBarHeight;
  late final Computed<double> trueToolBarHeight;
  late final Computed<double> trueBottomOverlayHeight;
  late final Computed<double> trueAppBarHeight;
  late final Computed<bool> shouldHaveSideBarButton;
  late final Computed<bool> shouldHaveFab;
  late final Computed<bool> shouldHaveEitherFab;
  late final Computed<EdgeInsets> scaffoldPadding;
  late final Computed<double> fabBottomPadding;
  late final Computed<double> bottomScaffoldSafeAreaHeight;
  late final Computed<bool> shouldBodyHaveBottomScaffoldSafeArea;
  late final Computed<bool> shouldHaveDockedSideBar;
  late final Computed<bool> shouldHaveFloatingSideBar;
  late final Computed<double> trueSideBarWidth;
  late final Computed<EdgeInsetsGeometry> contentPadding;
  late final Computed<double> keyboardBottomInset;
  late final Computed<bool> isKeyboardOpen;
  late final Computed<double> toolbarViewportInset;
  late final Computed<double> contentBottomInset;
  late final Computed<double> effectiveBottomScaffoldSafeAreaHeight;
  late final Computed<double> scaffoldOverlayBottomInset;
  late final Computed<bool> effectiveScrollable;
  late final Computed<bool> shouldShowUnfocusButton;

  static const animationDuration = Duration(milliseconds: 220);

  void initializeComputedSignals() {
    shouldHaveAppBar = computed(
      () => appBar != null && showAppBar.value && !isFloatingAppBar,
    );
    shouldHaveFloatingAppBar = computed(
      () => appBar != null && showAppBar.value && isFloatingAppBar,
    );
    shouldHaveEitherAppBar = computed(
      () => shouldHaveAppBar.value || shouldHaveFloatingAppBar.value,
    );
    shouldHaveToolBar = computed(
      () => toolBar != null && isUserInputFocusing.value,
    );
    shouldHaveBottomNavBar = computed(() {
      final isMobile = Breakpoints.isMobile(mediaQuery.size);
      return !hideNavigationSignal.value &&
          isMobile &&
          bottomNavBar != null &&
          showBottomNavBar.value &&
          !shouldHaveToolBar.value;
    });
    shouldInheritMainBottomNavBarHeight = computed(() {
      final isKeyboardOpen = mediaQuery.viewInsets.bottom > 0;
      return inheritMainBottomNavBarHeight &&
          mainController.isBottomNavBarVisible.value &&
          !isKeyboardOpen;
    });
    trueBottomNavBarHeight = computed(() {
      if (shouldInheritMainBottomNavBarHeight.value) {
        return mainController.bottomNavBarHeight +
            mediaQuery.viewPadding.bottom;
      }
      if (shouldHaveBottomNavBar.value) {
        return bottomNavBar!.preferredSize.height +
            mediaQuery.viewPadding.bottom;
      }
      return 0;
    });
    trueToolBarHeight = computed(() {
      final isKeyboardOpen = mediaQuery.viewInsets.bottom > 50;
      if (shouldHaveToolBar.value) {
        return toolBar!.preferredSize.height +
            (isKeyboardOpen ? 0 : mediaQuery.viewPadding.bottom);
      }
      return 0;
    });
    trueBottomOverlayHeight = computed(
      () => shouldHaveToolBar.value
          ? trueToolBarHeight.value
          : trueBottomNavBarHeight.value,
    );
    trueAppBarHeight = computed(
      () => shouldHaveEitherAppBar.value
          ? appBar!.preferredSize.height + mediaQuery.viewPadding.top
          : 0,
    );
    shouldHaveSideBarButton = computed(
      () => haveSideBarOpenButton && !shouldHaveToolBar.value,
    );
    shouldHaveFab = computed(
      () => floatingActionButton != null && !shouldHaveToolBar.value,
    );
    shouldHaveEitherFab = computed(
      () => shouldHaveSideBarButton.value || shouldHaveFab.value,
    );
    scaffoldPadding = computed(
      () => PlatformService.getScaffoldPadding(tokens),
    );
    fabBottomPadding = computed(
      () =>
          tokens.spaceLayoutGapMd +
          (trueBottomOverlayHeight.value == 0
              ? mediaQuery.viewPadding.bottom
              : trueBottomOverlayHeight.value),
    );
    bottomScaffoldSafeAreaHeight = computed(() {
      final floatingActionButtonBottomHeight = shouldHaveEitherFab.value
          ? fabBottomPadding.value + preferredFloatingActionButtonHeight
          : 0.0;
      return math.max(
        trueBottomOverlayHeight.value,
        floatingActionButtonBottomHeight,
      );
    });
    shouldBodyHaveBottomScaffoldSafeArea = computed(
      () =>
          (shouldHaveToolBar.value ||
              shouldHaveBottomNavBar.value ||
              shouldHaveEitherFab.value ||
              shouldInheritMainBottomNavBarHeight.value) &&
          haveBottomNavBarBottomGap,
    );
    shouldHaveDockedSideBar = computed(() {
      final isMobile = Breakpoints.isMobile(mediaQuery.size);
      return !hideNavigationSignal.value &&
          !isMobile &&
          sidebar != null &&
          !isFloatingSideBarSignal.value;
    });
    shouldHaveFloatingSideBar = computed(() {
      final isMobile = Breakpoints.isMobile(mediaQuery.size);
      return !hideNavigationSignal.value &&
          sidebar != null &&
          (isFloatingSideBarSignal.value || isMobile || haveSideBarOpenButton);
    });
    trueSideBarWidth = computed(
      () => shouldHaveDockedSideBar.value ? sidebarWidth : 0.0,
    );
    contentPadding = computed(() => padding ?? scaffoldPadding.value);
    keyboardBottomInset = computed(
      () => resizeBodyForKeyboard ? mediaQuery.viewInsets.bottom : 0.0,
    );
    isKeyboardOpen = computed(() => keyboardBottomInset.value > 0);
    toolbarViewportInset = computed(
      () => isKeyboardOpen.value && shouldHaveToolBar.value
          ? trueToolBarHeight.value
          : 0.0,
    );
    contentBottomInset = computed(
      () => keyboardBottomInset.value + toolbarViewportInset.value,
    );
    effectiveBottomScaffoldSafeAreaHeight = computed(
      () => isKeyboardOpen.value && shouldHaveToolBar.value
          ? 0.0
          : bottomScaffoldSafeAreaHeight.value,
    );
    scaffoldOverlayBottomInset = computed(
      () => math.max(
        bottomScaffoldSafeAreaHeight.value,
        contentBottomInset.value,
      ),
    );
    effectiveScrollable = computed(
      () => scrollable && scrollLockKeys.value.isEmpty,
    );
    shouldShowUnfocusButton = computed(
      () => showUnfocusButton && mediaQuery.viewInsets.bottom <= 0,
    );
  }

  void setScrollLocked(Object key, bool value) {
    if (isDisposed || scrollLockKeys.disposed) return;

    final next = {...scrollLockKeys.value};
    final didChange = value ? next.add(key) : next.remove(key);
    if (didChange) scrollLockKeys.value = next;
  }

  void syncUserInputFocus() {
    if (isDisposed) return;

    final focusedContext = FocusManager.instance.primaryFocus?.context;
    isUserInputFocusing.value =
        focusedContext?.widget is EditableText ||
        focusedContext?.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  void addFocusListener() {
    FocusManager.instance.addListener(syncUserInputFocus);
    syncUserInputFocus();
  }

  void removeFocusListener() {
    FocusManager.instance.removeListener(syncUserInputFocus);
  }

  void toggleSideBarVisibility() {
    if (isDisposed) return;

    isSideBarVisible.value = !isSideBarVisible.value;
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (isDisposed) return false;

    if (notification.metrics.axis != Axis.vertical) return false;
    if (notification.metrics.pixels <= 0) {
      if (hideBottomNavigationBarOnScroll) isBottomNavBarVisible.value = true;
      if (hideAppBarOnScroll) isEitherAppBarVisible.value = true;
      if (hideFloatingActionButtonOnScroll) isEitherFabVisible.value = true;
      return false;
    }

    final direction = switch (notification) {
      UserScrollNotification(:final direction) => direction,
      _ => ScrollDirection.idle,
    };
    if (direction == ScrollDirection.idle) return false;
    if (hideBottomNavigationBarOnScroll) {
      isBottomNavBarVisible.value = direction == ScrollDirection.forward;
    }
    if (hideAppBarOnScroll) {
      isEitherAppBarVisible.value = direction == ScrollDirection.forward;
    }
    if (hideFloatingActionButtonOnScroll) {
      isEitherFabVisible.value = direction == ScrollDirection.forward;
    }
    return false;
  }

  bool get isKeyboardVisible =>
      UniteKeyboardVisibility.instance.value == KeyboardVisibilityStatus.open;

  void dispose() {
    if (isDisposed) return;
    isDisposed = true;
    removeFocusListener();

    hideNavigationSignal.dispose();
    showBottomNavBar.dispose();
    showAppBar.dispose();
    isFloatingSideBarSignal.dispose();
    isBottomNavBarVisible.dispose();
    isEitherAppBarVisible.dispose();
    isSideBarVisible.dispose();
    isEitherFabVisible.dispose();
    isUserInputFocusing.dispose();
    scrollLockKeys.dispose();
    shouldHaveAppBar.dispose();
    shouldHaveFloatingAppBar.dispose();
    shouldHaveEitherAppBar.dispose();
    shouldHaveBottomNavBar.dispose();
    shouldHaveToolBar.dispose();
    shouldInheritMainBottomNavBarHeight.dispose();
    trueBottomNavBarHeight.dispose();
    trueToolBarHeight.dispose();
    trueBottomOverlayHeight.dispose();
    trueAppBarHeight.dispose();
    shouldHaveSideBarButton.dispose();
    shouldHaveFab.dispose();
    shouldHaveEitherFab.dispose();
    scaffoldPadding.dispose();
    fabBottomPadding.dispose();
    bottomScaffoldSafeAreaHeight.dispose();
    shouldBodyHaveBottomScaffoldSafeArea.dispose();
    shouldHaveDockedSideBar.dispose();
    shouldHaveFloatingSideBar.dispose();
    trueSideBarWidth.dispose();
    contentPadding.dispose();
    keyboardBottomInset.dispose();
    isKeyboardOpen.dispose();
    toolbarViewportInset.dispose();
    contentBottomInset.dispose();
    effectiveBottomScaffoldSafeAreaHeight.dispose();
    scaffoldOverlayBottomInset.dispose();
    effectiveScrollable.dispose();
    shouldShowUnfocusButton.dispose();
  }
}

typedef ScaffoldRefreshBuilder =
    Widget Function(
      BuildContext context,
      RefreshCallback onRefresh,
      Widget child,
    );

typedef ScaffoldScrollLockSetter = void Function(Object key, bool value);
