import 'package:boo_mondai/features/main/main.controller.dart';
import 'package:boo_mondai/lib.barrel.dart' show AppTokens, Breakpoints;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.sidebar,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.maxWidth,
    this.padding,
    this.hideNavigation = false,
    this.hideBottomNavigationBarOnScroll = false,
    this.scrollable = true,
    this.safeArea = true,
    this.center = true,
    this.constrainWidth = true,
    this.floatingActionButton,
  });

  final Widget body;
  final Widget? appBar;
  final Widget? sidebar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool hideNavigation;
  final bool hideBottomNavigationBarOnScroll;
  final bool scrollable;
  final bool safeArea;
  final bool center;
  final bool constrainWidth;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
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
        final hasResponsiveRequirements =
            !hideNavigation && sidebar != null && bottomNavigationBar != null;
        final isMobile = Breakpoints.isMobile(constraints.biggest);

        final mainController = context.watch<MainController>();

        return Scaffold(
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar != null
              ? _AnimatedBottomNavbar(
                  isVisible: mainController.isBottomNavbarVisible,
                  child: bottomNavigationBar!,
                )
              : null,
          backgroundColor: backgroundColor ?? tokens.colorScaffoldBackground,
          body: Column(
            children: [
              appBar ?? SizedBox.shrink(),
              Expanded(
                child: _autoHideBottomNavbarWrapper(
                  controller: mainController,
                  child: content,
                  disabled: !hideBottomNavigationBarOnScroll,
                  showSidebar: hasResponsiveRequirements && !isMobile,
                  sidebar: sidebar,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _autoHideBottomNavbarWrapper({
  required Widget child,
  required bool disabled,
  required MainController controller,
  required bool showSidebar,
  Widget? sidebar,
}) {
  return NotificationListener<UserScrollNotification>(
    onNotification: (notification) {
      if (disabled) return false;

      switch (notification.direction) {
        case ScrollDirection.reverse:
          controller.hideBottomNavbar();
        case ScrollDirection.forward:
          controller.showBottomNavbar();
        case ScrollDirection.idle:
          break;
      }

      return false;
    },
    child: showSidebar && sidebar != null
        ? Row(children: [sidebar, VerticalDivider(), child])
        : child,
  );
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
