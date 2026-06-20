import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Breakpoints, Button, MainController;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        Color,
        EdgeInsetsGeometry,
        UserScrollNotification,
        VerticalDivider,
        Offset,
        VoidCallback,
        StatelessWidget,
        ValueKey,
        SizedBox,
        EdgeInsets,
        Padding,
        ClipRect,
        BoxConstraints,
        ConstrainedBox,
        Center,
        SingleChildScrollView,
        Expanded,
        Column,
        LayoutBuilder,
        MediaQuery,
        NotificationListener,
        Row,
        Positioned,
        Curves,
        AnimatedSlide,
        AnimatedOpacity,
        IgnorePointer,
        Stack,
        MainAxisSize,
        Icons,
        KeyedSubtree,
        CurvedAnimation,
        Alignment,
        Tween,
        SlideTransition,
        SizeTransition,
        AnimatedSwitcher,
        SafeArea;
import 'package:flutter/material.dart' as material show Scaffold;
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_hooks/flutter_hooks.dart' show useState, HookWidget;
import 'package:provider/provider.dart' show WatchContext;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

typedef MScaffold = Scaffold;

class Scaffold extends HookWidget {
  const Scaffold({
    super.key,
    required this.body,
    this.appBar,
    this.sidebar,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.maxWidth,
    this.padding,
    this.hideNavigation = false,
    this.hideAppBarOnScroll = false,
    this.hideBottomNavigationBarOnScroll = false,
    this.hideFloatingActionButtonOnScroll = false,
    this.onlyShowFloatingActionButtonsWhenTyping = false,
    this.hideFloatingActionButtonsWhenTyping = false,
    this.scrollable = true,
    this.safeArea = true,
    this.center = true,
    this.constrainWidth = true,
    this.floatingActionButton,
    this.floatingSidebar = false,
    this.floatingSidebarInitiallyOpen = false,
    this.haveSidebarOpenButton = false,
  }) : assert(
         !onlyShowFloatingActionButtonsWhenTyping ||
             !hideFloatingActionButtonsWhenTyping,
         'onlyShowFloatingActionButtonsWhenTyping and '
         'hideFloatingActionButtonsWhenTyping cannot both be true.',
       );

  final Widget body;
  final Widget? appBar;
  final Widget? sidebar;
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
  final bool constrainWidth;
  final Widget? floatingActionButton;
  final bool floatingSidebar;
  final bool floatingSidebarInitiallyOpen;
  final bool haveSidebarOpenButton;

  @override
  Widget build(BuildContext context) {
    final isFloatingSidebarOpen = useState(floatingSidebarInitiallyOpen);
    final isAppBarVisible = useState(true);
    final isFloatingActionButtonVisible = useState(true);
    final isTyping = MediaQuery.viewInsetsOf(context).bottom > 0;
    final tokens = context.themeTokens<AppTokens>();
    final effectiveMaxWidth = maxWidth ?? tokens.spaceScaffoldMaxWidth;
    final effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: tokens.spaceScaffoldPadding,
          vertical: tokens.spaceScaffoldPaddingMobileY,
        );

    Widget content = Padding(padding: effectivePadding, child: body);

    if (constrainWidth) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: content,
      );
    }

    if (center) {
      content = Center(child: content);
    }

    // if (safeArea) {
    //   content = SafeArea(child: content);
    // }

    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Breakpoints.isMobile(constraints.biggest);
        final useFloatingSidebar = floatingSidebar || haveSidebarOpenButton;
        final canShowSidebar = !hideNavigation && sidebar != null;
        final showSidebar = canShowSidebar && (useFloatingSidebar || !isMobile);

        final mainController = context.watch<MainController>();
        final scaffoldBody = _withSidebar(
          child: content,
          showSidebar: showSidebar,
          sidebar: sidebar,
          floatingSidebar: useFloatingSidebar,
          isFloatingSidebarOpen: isFloatingSidebarOpen.value,
        );
        final floatingActionButtonRow = _floatingActionButtonRow(
          floatingActionButton: floatingActionButton,
          showSidebarOpenButton:
              canShowSidebar && useFloatingSidebar && haveSidebarOpenButton,
          isSidebarOpen: isFloatingSidebarOpen.value,
          onSidebarOpenButtonPressed: () {
            isFloatingSidebarOpen.value = !isFloatingSidebarOpen.value;
          },
          tokens: tokens,
        );
        final effectiveFloatingActionButton = floatingActionButtonRow == null
            ? null
            : _AnimatedFloatingActionButton(
                isVisible:
                    !hideFloatingActionButtonOnScroll ||
                    isFloatingActionButtonVisible.value,
                onlyShowWhenTyping: onlyShowFloatingActionButtonsWhenTyping,
                hideWhenTyping: hideFloatingActionButtonsWhenTyping,
                isTyping: isTyping,
                child: floatingActionButtonRow,
              );

        final body = Column(
          children: [
            if (appBar != null)
              _AnimatedAppBar(isVisible: isAppBarVisible.value, child: appBar!),
            Expanded(
              child: _autoHideNavigationWrapper(
                controller: mainController,
                onShowAppBar: () => isAppBarVisible.value = true,
                onHideAppBar: () => isAppBarVisible.value = false,
                onShowFloatingActionButton: () {
                  isFloatingActionButtonVisible.value = true;
                },
                onHideFloatingActionButton: () {
                  isFloatingActionButtonVisible.value = false;
                },
                child: scaffoldBody,
                hideAppBarOnScroll: hideAppBarOnScroll,
                hideBottomNavigationBarOnScroll:
                    hideBottomNavigationBarOnScroll,
                hideFloatingActionButtonOnScroll:
                    hideFloatingActionButtonOnScroll,
              ),
            ),
          ],
        );

        return material.Scaffold(
          floatingActionButton: effectiveFloatingActionButton,
          bottomNavigationBar: bottomNavigationBar != null
              ? _AnimatedBottomNavbar(
                  isVisible:
                      !hideBottomNavigationBarOnScroll ||
                      mainController.isBottomNavbarVisible,
                  child: bottomNavigationBar!,
                )
              : null,
          backgroundColor: backgroundColor ?? tokens.colorScaffoldBackground,
          body: safeArea ? SafeArea(child: body) : body,
        );
      },
    );
  }
}

Widget _autoHideNavigationWrapper({
  required Widget child,
  required bool hideAppBarOnScroll,
  required bool hideBottomNavigationBarOnScroll,
  required bool hideFloatingActionButtonOnScroll,
  required MainController controller,
  required VoidCallback onShowAppBar,
  required VoidCallback onHideAppBar,
  required VoidCallback onShowFloatingActionButton,
  required VoidCallback onHideFloatingActionButton,
}) {
  return NotificationListener<UserScrollNotification>(
    onNotification: (notification) {
      if (!hideAppBarOnScroll &&
          !hideBottomNavigationBarOnScroll &&
          !hideFloatingActionButtonOnScroll) {
        return false;
      }

      switch (notification.direction) {
        case ScrollDirection.reverse:
          if (hideAppBarOnScroll) {
            onHideAppBar();
          }
          if (hideBottomNavigationBarOnScroll) {
            controller.hideBottomNavbar();
          }
          if (hideFloatingActionButtonOnScroll) {
            onHideFloatingActionButton();
          }
        case ScrollDirection.forward:
          if (hideAppBarOnScroll) {
            onShowAppBar();
          }
          if (hideBottomNavigationBarOnScroll) {
            controller.showBottomNavbar();
          }
          if (hideFloatingActionButtonOnScroll) {
            onShowFloatingActionButton();
          }
        case ScrollDirection.idle:
          break;
      }

      return false;
    },
    child: child,
  );
}

class _AnimatedAppBar extends StatelessWidget {
  const _AnimatedAppBar({required this.isVisible, required this.child});

  static const _duration = Duration(milliseconds: 180);

  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedOpacity(
          duration: _duration,
          curve: Curves.easeOutCubic,
          opacity: isVisible ? 1 : 0,
          child: AnimatedSlide(
            duration: _duration,
            curve: Curves.easeOutCubic,
            offset: isVisible ? Offset.zero : const Offset(0, -1),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _AnimatedFloatingActionButton extends StatelessWidget {
  const _AnimatedFloatingActionButton({
    required this.isVisible,
    required this.onlyShowWhenTyping,
    required this.hideWhenTyping,
    required this.isTyping,
    required this.child,
  });

  static const _duration = Duration(milliseconds: 180);

  final bool isVisible;
  final bool onlyShowWhenTyping;
  final bool hideWhenTyping;
  final bool isTyping;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final typingVisible =
        (!onlyShowWhenTyping || isTyping) && (!hideWhenTyping || !isTyping);
    final effectiveVisible = isVisible && typingVisible;

    return IgnorePointer(
      ignoring: !effectiveVisible,
      child: AnimatedOpacity(
        duration: _duration,
        curve: Curves.easeOutCubic,
        opacity: effectiveVisible ? 1 : 0,
        child: AnimatedSlide(
          duration: _duration,
          curve: Curves.easeOutCubic,
          offset: effectiveVisible ? Offset.zero : const Offset(0, 1),
          child: child,
        ),
      ),
    );
  }
}

class _AnimatedBottomNavbar extends StatelessWidget {
  const _AnimatedBottomNavbar({required this.isVisible, required this.child});

  static const _duration = Duration(milliseconds: 180);

  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _duration,
      reverseDuration: _duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return SizeTransition(
          sizeFactor: curved,
          alignment: Alignment.topCenter,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      child: isVisible
          ? KeyedSubtree(key: const ValueKey('shown'), child: child)
          : const SizedBox.shrink(key: ValueKey('hidden')),
    );
  }
}

Widget _withSidebar({
  required Widget child,
  required bool showSidebar,
  required bool floatingSidebar,
  required bool isFloatingSidebarOpen,
  Widget? sidebar,
}) {
  if (!showSidebar || sidebar == null) {
    return child;
  }

  if (!floatingSidebar) {
    return Row(
      children: [
        sidebar,
        const VerticalDivider(width: 1),
        Expanded(child: child),
      ],
    );
  }

  return Stack(
    children: [
      Positioned.fill(child: child),
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        child: IgnorePointer(
          ignoring: !isFloatingSidebarOpen,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            offset: isFloatingSidebarOpen ? Offset.zero : const Offset(-1, 0),
            child: sidebar,
          ),
        ),
      ),
    ],
  );
}

Widget? _floatingActionButtonRow({
  required Widget? floatingActionButton,
  required bool showSidebarOpenButton,
  required bool isSidebarOpen,
  required VoidCallback onSidebarOpenButtonPressed,
  required AppTokens tokens,
}) {
  if (floatingActionButton == null && !showSidebarOpenButton) {
    return null;
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    spacing: tokens.spaceLayoutGapSm,
    children: [
      ?floatingActionButton,
      if (showSidebarOpenButton)
        Button.icon(
          icon: isSidebarOpen ? Icons.close : Icons.menu,
          onPressed: onSidebarOpenButtonPressed,
        ),
    ],
  );
}
