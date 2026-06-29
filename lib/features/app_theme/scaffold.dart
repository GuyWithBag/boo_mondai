import 'package:boo_mondai/core/theme/breakpoints.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, ButtonColor, ButtonVariant, MainController;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter/material.dart' as material show Scaffold;
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart' show WatchContext;
import 'package:theme_variants/theme_variants.dart';

class Scaffold extends HookWidget {
  const Scaffold({
    super.key,
    required this.body,
    this.appBar,
    this.sidebar,
    this.sidebarWidth = 280,
    this.bottomNavBar,
    this.backgroundColor,
    this.maxWidth,
    this.padding,
    this.hideNavigation = false,
    this.hideAppBarOnScroll = false,
    this.hideBottomNavigationBarOnScroll = false,
    this.hideFloatingActionButtonOnScroll = false,
    this.onlyShowFloatingActionButtonsWhenTyping = false,
    this.hideFloatingActionButtonsWhenTyping = true,
    this.scrollable = true,
    this.safeArea = true,
    this.center = false,
    this.shouldConstrainWidth = false,
    this.floatingActionButton,
    this.floatingSideBar = false,
    this.floatingSideBarInitiallyOpen = false,
    this.haveSideBarOpenButton = false,
    this.haveBottomNavBarBottomGap = true,
    this.showBottomNavBar = true,
    this.showAppBar = true,
    this.isFloatingAppBar = false,
    this.inheritMainBottomNavBarHeight = true,
    this.scrollController,
  }) : assert(
         !onlyShowFloatingActionButtonsWhenTyping ||
             !hideFloatingActionButtonsWhenTyping,
         'onlyShowFloatingActionButtonsWhenTyping and '
         'hideFloatingActionButtonsWhenTyping cannot both be true.',
       ),
       assert(sidebarWidth >= 0, 'sidebarWidth cannot be negative.');

  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool isFloatingAppBar;
  final Widget? sidebar;
  final double sidebarWidth;
  final PreferredSizeWidget? bottomNavBar;
  final Color? backgroundColor;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool hideNavigation;
  final bool hideAppBarOnScroll;
  final bool hideBottomNavigationBarOnScroll;
  final bool hideFloatingActionButtonOnScroll;
  final bool onlyShowFloatingActionButtonsWhenTyping;
  final bool hideFloatingActionButtonsWhenTyping;
  final bool scrollable;
  final bool safeArea;
  final bool center;
  final bool shouldConstrainWidth;
  final Widget? floatingActionButton;
  final bool showBottomNavBar;
  final bool showAppBar;
  final bool floatingSideBar;
  final bool floatingSideBarInitiallyOpen;
  final bool haveSideBarOpenButton;
  final bool haveBottomNavBarBottomGap;
  final bool inheritMainBottomNavBarHeight;
  final ScrollController? scrollController;

  static const _animationDuration = Duration(milliseconds: 220);
  static const _fabMargin = 20.0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final mediaQuery = MediaQuery.of(context);
    final viewportSize = mediaQuery.size;
    final isMobile = Breakpoints.isMobile(viewportSize);
    final keyboardVisible = mediaQuery.viewInsets.bottom > 0;
    final mainController = context.watch<MainController>();
    final shouldHaveAppBar = appBar != null && showAppBar && !isFloatingAppBar;
    final shouldHaveFloatingAppBar =
        appBar != null && showAppBar && isFloatingAppBar;
    final shouldHaveBottomNavBar =
        !hideNavigation &&
        isMobile &&
        (bottomNavBar != null) &&
        showBottomNavBar;
    final shouldHaveBottomNavBarGap =
        (shouldHaveBottomNavBar || inheritMainBottomNavBarHeight) &&
        haveBottomNavBarBottomGap;

    double getTrueBottomNavBarHeight() {
      if (inheritMainBottomNavBarHeight) {
        return mainController.bottomNavBarHeight +
            mediaQuery.viewPadding.bottom;
      }
      if (shouldHaveBottomNavBar) {
        return bottomNavBar!.preferredSize.height +
            mediaQuery.viewPadding.bottom;
      }
      return 0;
    }

    double getTrueAppBarHeight() {
      if (shouldHaveAppBar || shouldHaveFloatingAppBar) {
        return appBar!.preferredSize.height + mediaQuery.viewPadding.top;
      }
      return 0;
    }

    final double effectiveBottomNavBarHeight = getTrueBottomNavBarHeight();
    final double effectiveAppBarHeight = getTrueAppBarHeight();

    final isBottomNavBarVisible = useState(shouldHaveBottomNavBar);
    final shouldHaveEitherAppBar = shouldHaveAppBar || shouldHaveFloatingAppBar;
    final isEitherAppBarVisible = useState(shouldHaveEitherAppBar);

    final isSideBarVisible = useState(floatingSideBarInitiallyOpen);

    bool handleScrollNotification(ScrollNotification notification) {
      if (notification.metrics.axis != Axis.vertical) {
        return false;
      }

      if (notification.metrics.pixels <= 0) {
        if (hideBottomNavigationBarOnScroll) isBottomNavBarVisible.value = true;
        if (hideAppBarOnScroll) isEitherAppBarVisible.value = true;
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
      return false;
    }

    final showDockedSideBar =
        !hideNavigation && !isMobile && sidebar != null && !floatingSideBar;
    final showFloatingSideBar =
        !hideNavigation &&
        sidebar != null &&
        (floatingSideBar || isMobile || haveSideBarOpenButton);

    final effectiveSideBarWidth = showDockedSideBar ? sidebarWidth : 0.0;

    final contentPadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: tokens.spaceScaffoldPadding,
          vertical: tokens.spaceScaffoldPaddingMobileY,
        );

    final paddedBody = Padding(padding: contentPadding, child: body);

    Widget content = paddedBody;

    if (safeArea) {
      content = SafeArea(
        top: shouldHaveAppBar,
        bottom: shouldHaveBottomNavBar,
        child: content,
      );
    }

    content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: scrollable ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (shouldHaveAppBar) SizedBox(height: effectiveAppBarHeight),
        if (!shouldHaveFloatingAppBar)
          Flexible(child: paddedBody)
        else
          Stack(
            children: [
              paddedBody,
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: effectiveAppBarHeight,
                  child: _AnimatedOverlay(
                    visible: isEitherAppBarVisible.value,
                    hiddenOffset: const Offset(0, -1),
                    child: appBar!,
                  ),
                ),
              ),
            ],
          ),
        if (shouldHaveBottomNavBarGap)
          SizedBox(height: effectiveBottomNavBarHeight),
      ],
    );

    if (scrollable) {
      content = SingleChildScrollView(
        padding: EdgeInsets.zero,
        controller: scrollController,
        child: content,
      );
    }

    if (shouldConstrainWidth) {
      content = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? tokens.spaceScaffoldMaxWidth,
        ),
        child: content,
      );
    }

    // if (center) {
    //   content = Align(alignment: Alignment.topCenter, child: content);
    // }

    content = NotificationListener<ScrollNotification>(
      onNotification: handleScrollNotification,
      child: content,
    );

    final stackChildren = <Widget>[
      Positioned.fill(child: content),
      if (showDockedSideBar)
        _AnimatedOverlay(
          visible: true,
          hiddenOffset: const Offset(-1, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: sidebarWidth, child: sidebar!),
          ),
        ),
      if (shouldHaveAppBar)
        Positioned(
          top: 0,
          left: effectiveSideBarWidth,
          right: 0,
          child: _AnimatedOverlay(
            visible: isEitherAppBarVisible.value,
            hiddenOffset: const Offset(0, -1),
            child: SizedBox(height: effectiveAppBarHeight, child: appBar!),
          ),
        ),
      if (shouldHaveBottomNavBar)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _AnimatedOverlay(
            visible: isBottomNavBarVisible.value,
            // visible: true,
            hiddenOffset: const Offset(0, 1),
            child: SizedBox(
              height: effectiveBottomNavBarHeight,
              child: bottomNavBar!,
            ),
          ),
        ),
      if (showFloatingSideBar)
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !isSideBarVisible.value,
            child: AnimatedOpacity(
              opacity: isSideBarVisible.value ? 1 : 0,
              duration: _animationDuration,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => isSideBarVisible.value = false,
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.24),
                      ),
                    ),
                  ),
                  _AnimatedOverlay(
                    visible: isSideBarVisible.value,
                    hiddenOffset: const Offset(-1, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SafeArea(
                        right: false,
                        child: SizedBox(width: sidebarWidth, child: sidebar!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ..._floatingActionButtons(
        context: context,
        tokens: tokens,
        visible: _showFloatingActionButtons(
          isBottomNavBarVisible: isBottomNavBarVisible.value,
          keyboardVisible: keyboardVisible,
        ),
        bottomInset: shouldHaveBottomNavBar ? effectiveBottomNavBarHeight : 0,
        onOpenSideBar: showFloatingSideBar || showDockedSideBar
            ? () => isSideBarVisible.value = !isSideBarVisible.value
            : null,
      ),
    ];

    return material.Scaffold(
      backgroundColor: backgroundColor ?? tokens.colorScaffoldBackground,
      body: Stack(clipBehavior: Clip.none, children: stackChildren),
    );
  }

  bool _showFloatingActionButtons({
    required bool isBottomNavBarVisible,
    required bool keyboardVisible,
  }) {
    if (hideFloatingActionButtonOnScroll && isBottomNavBarVisible) {
      return false;
    }
    if (onlyShowFloatingActionButtonsWhenTyping && !keyboardVisible) {
      return false;
    }
    if (hideFloatingActionButtonsWhenTyping && keyboardVisible) {
      return false;
    }
    return true;
  }

  List<Widget> _floatingActionButtons({
    required BuildContext context,
    required AppTokens tokens,
    required bool visible,
    required double bottomInset,
    required VoidCallback? onOpenSideBar,
  }) {
    final children = <Widget>[];
    final bottom = _fabMargin + bottomInset;

    if (haveSideBarOpenButton && onOpenSideBar != null) {
      children.add(
        Positioned(
          left: _fabMargin,
          bottom: bottom,
          child: _AnimatedOverlay(
            visible: visible,
            hiddenOffset: const Offset(0, 1),
            child: Button.icon(
              icon: Icons.menu,
              onPressed: onOpenSideBar,
              color: ButtonColor.primary,
              variant: ButtonVariant.elevated,
              tokens: tokens,
            ),
          ),
        ),
      );
    }

    if (floatingActionButton != null) {
      children.add(
        Positioned(
          right: _fabMargin,
          bottom: bottom,
          child: _AnimatedOverlay(
            visible: visible,
            hiddenOffset: const Offset(0, 1),
            child: floatingActionButton!,
          ),
        ),
      );
    }

    return children;
  }
}

class _AnimatedOverlay extends StatelessWidget {
  const _AnimatedOverlay({
    required this.visible,
    required this.hiddenOffset,
    required this.child,
  });

  final bool visible;
  final Offset hiddenOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(target: visible ? 1 : 0)
        .fade(
          duration: Scaffold._animationDuration,
          curve: Curves.easeOutCubic,
          begin: 0,
          end: 1,
        )
        .slide(
          duration: Scaffold._animationDuration,
          curve: Curves.easeOutCubic,
          begin: hiddenOffset,
          end: Offset.zero,
        );
  }
}
