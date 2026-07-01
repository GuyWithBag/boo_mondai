import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        MainController,
        ScaffoldController,
        ScaffoldHelper,
        useScaffoldController;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter/material.dart' as material show Scaffold;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart' show WatchContext;
import 'package:theme_variants/theme_variants.dart';

class Scaffold extends HookWidget {
  const Scaffold({
    super.key,
    required this.body,
    this.controller,
    this.appBar,
    this.sidebar,
    this.sidebarWidth = 280,
    this.bottomNavBar,
    this.backgroundColor,
    this.maxWidth,
    this.padding,
    this.hideAppBarOnScroll = false,
    this.hideBottomNavigationBarOnScroll = false,
    this.hideFloatingActionButtonOnScroll = false,
    this.scrollable = true,
    this.safeArea = true,
    this.center = false,
    this.shouldConstrainWidth = false,
    this.floatingActionButton,
    this.floatingSideBarInitiallyOpen = false,
    this.haveSideBarOpenButton = false,
    this.haveBottomNavBarBottomGap = true,
    this.isFloatingAppBar = false,
    this.inheritMainBottomNavBarHeight = true,
    this.scrollController,
    this.resizeToAvoidBottomInset = false,
  }) : assert(sidebarWidth >= 0, 'sidebarWidth cannot be negative.');

  final Widget body;
  final ScaffoldController? controller;
  final PreferredSizeWidget? appBar;
  final bool isFloatingAppBar;
  final Widget? sidebar;
  final double sidebarWidth;
  final PreferredSizeWidget? bottomNavBar;
  final Color? backgroundColor;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool hideAppBarOnScroll;
  final bool hideBottomNavigationBarOnScroll;
  final bool hideFloatingActionButtonOnScroll;

  final bool scrollable;
  final bool safeArea;
  final bool center;
  final bool shouldConstrainWidth;
  final Widget? floatingActionButton;
  final bool floatingSideBarInitiallyOpen;
  final bool haveSideBarOpenButton;
  final bool haveBottomNavBarBottomGap;
  final bool inheritMainBottomNavBarHeight;
  final ScrollController? scrollController;
  final bool resizeToAvoidBottomInset;

  static const _animationDuration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final mediaQuery = MediaQuery.of(context);
    final mainController = context.watch<MainController>();

    final internalController = useScaffoldController(
      isSideBarVisible: floatingSideBarInitiallyOpen,
    );
    final controller = this.controller ?? internalController;

    final helper = ScaffoldHelper(
      tokens: tokens,
      mediaQuery: mediaQuery,
      mainController: mainController,
      appBar: appBar,
      sidebar: sidebar,
      sidebarWidth: sidebarWidth,
      bottomNavBar: bottomNavBar,
      padding: padding,
      hideNavigation: controller.hideNavigation,
      floatingActionButton: floatingActionButton,
      showBottomNavBar: controller.showBottomNavBar,
      showAppBar: controller.showAppBar,
      isFloatingSideBar: controller.isFloatingSideBar,
      isFloatingAppBar: isFloatingAppBar,
      haveSideBarOpenButton: haveSideBarOpenButton,
      haveBottomNavBarBottomGap: haveBottomNavBarBottomGap,
      inheritMainBottomNavBarHeight: inheritMainBottomNavBarHeight,
    );

    final shouldHaveAppBar = helper.shouldHaveAppBar;
    final shouldHaveFloatingAppBar = helper.shouldHaveFloatingAppBar;
    final shouldHaveBottomNavBar = helper.shouldHaveBottomNavBar;
    final shouldBodyHaveBottomScaffoldSafeArea =
        helper.shouldBodyHaveBottomScaffoldSafeArea;
    final effectiveBottomNavBarHeight = helper.trueBottomNavBarHeight;
    final effectiveAppBarHeight = helper.trueAppBarHeight;
    final showDockedSideBar = helper.shouldHaveDockedSideBar;
    final showFloatingSideBar = helper.shouldHaveFloatingSideBar;
    final effectiveSideBarWidth = helper.trueSideBarWidth;
    final shouldHaveSideBarButton = helper.shouldHaveSideBarButton;
    final shouldHaveEitherFab = helper.shouldHaveEitherFab;
    final scaffoldPadding = helper.scaffoldPadding;
    final fabBottomPadding = helper.fabBottomPadding;

    final paddedBody = Padding(padding: helper.contentPadding, child: body);

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
        if (shouldHaveFloatingAppBar)
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
                    visible: controller.isEitherAppBarVisible,
                    hiddenOffset: const Offset(0, -1),
                    child: appBar!,
                  ),
                ),
              ),
            ],
          )
        else
          Flexible(child: paddedBody),
        if (shouldBodyHaveBottomScaffoldSafeArea)
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
      onNotification: (notification) => controller.handleScrollNotification(
        notification: notification,
        hideBottomNavigationBarOnScroll: hideBottomNavigationBarOnScroll,
        hideAppBarOnScroll: hideAppBarOnScroll,
      ),
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
            visible: controller.isEitherAppBarVisible,
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
            visible: controller.isBottomNavBarVisible,
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
            ignoring: !controller.isSideBarVisible,
            child: AnimatedOpacity(
              opacity: controller.isSideBarVisible ? 1 : 0,
              duration: _animationDuration,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => controller.isSideBarVisible = false,
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.24),
                      ),
                    ),
                  ),
                  _AnimatedOverlay(
                    visible: controller.isSideBarVisible,
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

      if (shouldHaveEitherFab)
        Positioned(
          right: scaffoldPadding.right,
          bottom: fabBottomPadding,
          child: _AnimatedOverlay(
            visible: controller.isEitherFabVisible,
            hiddenOffset: const Offset(0, 1),
            child: Row(
              spacing: tokens.spaceLayoutGapSm,
              children: [
                if (shouldHaveSideBarButton)
                  Button.icon(
                    icon: Icons.menu,
                    onPressed: showFloatingSideBar || showDockedSideBar
                        ? controller.toggleSideBarVisibility
                        : null,
                    color: ButtonColor.baseline,
                    tokens: tokens,
                  ),

                ?floatingActionButton,
              ],
            ),
          ),
        ),
    ];

    return material.Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? tokens.colorScaffoldBackground,
      body: Stack(clipBehavior: Clip.none, children: stackChildren),
    );
  }
}

class _AnimatedOverlay extends HookWidget {
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
    final shouldBuild = useState(visible);

    useEffect(() {
      if (visible) shouldBuild.value = true;
      return null;
    }, [visible]);

    if (!shouldBuild.value) return const SizedBox.shrink();

    return IgnorePointer(
      ignoring: !visible,
      child: child
          .animate(
            target: visible ? 1 : 0,
            onComplete: (_) {
              if (!visible) shouldBuild.value = false;
            },
          )
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
          ),
    );
  }
}
