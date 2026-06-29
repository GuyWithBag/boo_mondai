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
    this.appBarHeight = 130,
    this.sidebar,
    this.sidebarWidth = 280,
    this.bottomNavigationBar,
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
    this.floatingSidebar = false,
    this.floatingSidebarInitiallyOpen = false,
    this.haveSidebarOpenButton = false,
    this.haveBottomNavbarBottomPadding = true,
    this.showBottomNavbar = true,
    this.showAppbar = true,
    this.isFloatingAppBar = false,
  }) : assert(
         !onlyShowFloatingActionButtonsWhenTyping ||
             !hideFloatingActionButtonsWhenTyping,
         'onlyShowFloatingActionButtonsWhenTyping and '
         'hideFloatingActionButtonsWhenTyping cannot both be true.',
       ),
       assert(appBarHeight >= 0, 'appBarHeight cannot be negative.'),
       assert(sidebarWidth >= 0, 'sidebarWidth cannot be negative.');

  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool isFloatingAppBar;
  final double appBarHeight;
  final Widget? sidebar;
  final double sidebarWidth;
  final Widget? bottomNavigationBar;
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
  final bool showBottomNavbar;
  final bool showAppbar;
  final bool floatingSidebar;
  final bool floatingSidebarInitiallyOpen;
  final bool haveSidebarOpenButton;
  final bool haveBottomNavbarBottomPadding;

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

    final shouldHaveAppbar = appBar != null && showAppbar && !isFloatingAppBar;
    final shouldHaveFloatingAppbar =
        appBar != null && showAppbar && isFloatingAppBar;
    final shouldHaveBottomNavbar =
        !hideNavigation &&
        isMobile &&
        (bottomNavigationBar != null) &&
        showBottomNavbar;

    final isBottomNavbarVisible = useState(shouldHaveBottomNavbar);
    final isAppbarVisible = useState(shouldHaveAppbar);

    final isSidebarVisible = useState(floatingSidebarInitiallyOpen);

    bool handleScrollNotification(ScrollNotification notification) {
      if (notification.metrics.axis != Axis.vertical) {
        return false;
      }

      if (notification.metrics.pixels <= 0) {
        if (hideBottomNavigationBarOnScroll) isBottomNavbarVisible.value = true;
        if (hideAppBarOnScroll) isAppbarVisible.value = true;
        return false;
      }

      final direction = switch (notification) {
        UserScrollNotification(:final direction) => direction,
        _ => ScrollDirection.idle,
      };

      if (direction == ScrollDirection.idle) return false;

      if (hideBottomNavigationBarOnScroll) {
        isBottomNavbarVisible.value = direction == ScrollDirection.forward;
      }
      if (hideAppBarOnScroll) {
        isAppbarVisible.value = direction == ScrollDirection.forward;
      }
      return false;
    }

    final showDockedSidebar =
        !hideNavigation && !isMobile && sidebar != null && !floatingSidebar;
    final showFloatingSidebar =
        !hideNavigation &&
        sidebar != null &&
        (floatingSidebar || isMobile || haveSidebarOpenButton);
    final bottomNavigationBarHeight = mainController.bottomNavbarHeight;
    // final effectiveBottomNavigationHeight = shouldHaveBottomNavbar
    //     ? bottomNavigationBarHeight
    //     : 0.0;
    final effectiveSidebarWidth = showDockedSidebar ? sidebarWidth : 0.0;

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
        top: shouldHaveAppbar,
        bottom: shouldHaveBottomNavbar,
        child: content,
      );
    }

    content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: scrollable ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (shouldHaveAppbar) SizedBox(height: appBar!.preferredSize.height),
        if (!shouldHaveFloatingAppbar)
          Flexible(child: paddedBody)
        else
          Stack(
            children: [
              paddedBody,
              Positioned(top: 0, left: 0, right: 0, child: appBar!),
            ],
          ),
        if (haveBottomNavbarBottomPadding)
          SizedBox(height: bottomNavigationBarHeight),
      ],
    );

    if (scrollable) {
      content = SingleChildScrollView(child: content);
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
      if (showDockedSidebar)
        _AnimatedOverlay(
          visible: true,
          hiddenOffset: const Offset(-1, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: sidebarWidth, child: sidebar!),
          ),
        ),
      if (shouldHaveAppbar)
        Positioned(
          top: 0,
          left: effectiveSidebarWidth,
          right: 0,
          child: _AnimatedOverlay(
            visible: isAppbarVisible.value,
            hiddenOffset: const Offset(0, -1),
            child: appBar!,
          ),
        ),
      if (shouldHaveBottomNavbar)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _AnimatedOverlay(
            visible: isBottomNavbarVisible.value,
            // visible: true,
            hiddenOffset: const Offset(0, 1),
            child: SizedBox(
              height: bottomNavigationBarHeight,
              child: bottomNavigationBar!,
            ),
          ),
        ),
      if (showFloatingSidebar)
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !isSidebarVisible.value,
            child: AnimatedOpacity(
              opacity: isSidebarVisible.value ? 1 : 0,
              duration: _animationDuration,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => isSidebarVisible.value = false,
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.24),
                      ),
                    ),
                  ),
                  _AnimatedOverlay(
                    visible: isSidebarVisible.value,
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
          isBottomNavbarVisible: isBottomNavbarVisible.value,
          keyboardVisible: keyboardVisible,
        ),
        bottomInset: shouldHaveBottomNavbar ? bottomNavigationBarHeight : 0,
        onOpenSidebar: showFloatingSidebar || showDockedSidebar
            ? () => isSidebarVisible.value = !isSidebarVisible.value
            : null,
      ),
    ];

    return material.Scaffold(
      backgroundColor: backgroundColor ?? tokens.colorScaffoldBackground,
      body: Stack(clipBehavior: Clip.none, children: stackChildren),
    );
  }

  bool _showFloatingActionButtons({
    required bool isBottomNavbarVisible,
    required bool keyboardVisible,
  }) {
    if (hideFloatingActionButtonOnScroll && isBottomNavbarVisible) {
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
    required VoidCallback? onOpenSidebar,
  }) {
    final children = <Widget>[];
    final bottom = _fabMargin + bottomInset;

    if (haveSidebarOpenButton && onOpenSidebar != null) {
      children.add(
        Positioned(
          left: _fabMargin,
          bottom: bottom,
          child: _AnimatedOverlay(
            visible: visible,
            hiddenOffset: const Offset(0, 1),
            child: Button.icon(
              icon: Icons.menu,
              onPressed: onOpenSidebar,
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
