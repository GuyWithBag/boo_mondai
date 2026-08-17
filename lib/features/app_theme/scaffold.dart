import 'dart:math' as math;

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        MainController,
        ScaffoldController,
        ScaffoldHelper,
        ScaffoldOverlayGeometry,
        ScaffoldScrollLockScope,
        ToolBar,
        ToolBarScope,
        useScaffoldController,
        ViewPaddingSizedBox,
        Side;
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
    this.toolBar,
    this.backgroundColor,
    this.maxWidth,
    this.padding,
    this.hideAppBarOnScroll = false,
    this.hideBottomNavigationBarOnScroll = false,
    this.hideFloatingActionButtonOnScroll = false,
    this.scrollable = true,
    this.safeArea = true,
    this.centeredConstraint = true,
    this.shouldConstrainWidth = false,
    this.floatingActionButton,
    this.preferredFloatingActionButtonHeight = 48,
    this.floatingSideBarInitiallyOpen = false,
    this.haveSideBarOpenButton = false,
    this.haveBottomNavBarBottomGap = true,
    this.isFloatingAppBar = false,
    this.inheritMainBottomNavBarHeight = true,
    this.scrollController,
    this.scrollStartAtTheBottom = false,
    this.resizeBodyForKeyboard = true,
    this.centeredBody = false,
    this.showUnfocusButton = true,
    this.showViewPaddingBottom = true,
    this.showViewPaddingTop = true,
  }) : assert(sidebarWidth >= 0, 'sidebarWidth cannot be negative.');

  final Widget body;
  final ScaffoldController? controller;
  final PreferredSizeWidget? appBar;
  final bool isFloatingAppBar;
  final Widget? sidebar;
  final double sidebarWidth;
  final PreferredSizeWidget? bottomNavBar;
  final PreferredSizeWidget? toolBar;
  final Color? backgroundColor;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool hideAppBarOnScroll;
  final bool hideBottomNavigationBarOnScroll;
  final bool hideFloatingActionButtonOnScroll;

  final bool scrollable;
  final bool safeArea;
  final bool centeredConstraint;
  final bool centeredBody;
  final bool shouldConstrainWidth;
  final Widget? floatingActionButton;
  final double preferredFloatingActionButtonHeight;
  final bool floatingSideBarInitiallyOpen;
  final bool haveSideBarOpenButton;
  final bool haveBottomNavBarBottomGap;
  final bool inheritMainBottomNavBarHeight;
  final ScrollController? scrollController;
  final bool scrollStartAtTheBottom;
  final bool resizeBodyForKeyboard;
  final bool showUnfocusButton;
  final bool showViewPaddingBottom;
  final bool showViewPaddingTop;

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
    final scrollLockKeys = useState(<Object>{});
    final isMounted = useRef(true);

    useEffect(() {
      isMounted.value = true;
      return () {
        isMounted.value = false;
      };
    }, const []);

    final setScrollLocked = useCallback((Object key, bool value) {
      if (!isMounted.value) return;

      final next = {...scrollLockKeys.value};
      final didChange = value ? next.add(key) : next.remove(key);

      if (didChange && isMounted.value) {
        scrollLockKeys.value = next;
      }
    }, [scrollLockKeys, isMounted]);

    final helper = ScaffoldHelper(
      tokens: tokens,
      mediaQuery: mediaQuery,
      mainController: mainController,
      appBar: appBar,
      sidebar: sidebar,
      sidebarWidth: sidebarWidth,
      bottomNavBar: bottomNavBar,
      toolBar: toolBar,
      padding: padding,
      hideNavigation: controller.hideNavigation,
      floatingActionButton: floatingActionButton,
      preferredFloatingActionButtonHeight: preferredFloatingActionButtonHeight,
      showBottomNavBar: controller.showBottomNavBar,
      showAppBar: controller.showAppBar,
      isFloatingSideBar: controller.isFloatingSideBar,
      isFloatingAppBar: isFloatingAppBar,
      haveSideBarOpenButton: haveSideBarOpenButton,
      haveBottomNavBarBottomGap: haveBottomNavBarBottomGap,
      inheritMainBottomNavBarHeight: inheritMainBottomNavBarHeight,
      isUserInputFocusing: controller.isUserInputFocusing,
    );

    useEffect(() {
      if (toolBar == null && !resizeBodyForKeyboard) {
        controller.isUserInputFocusing = false;
        return null;
      }

      void updateUserInputFocus() {
        final focusedContext = FocusManager.instance.primaryFocus?.context;
        controller.isUserInputFocusing =
            focusedContext?.widget is EditableText ||
            focusedContext?.findAncestorWidgetOfExactType<EditableText>() !=
                null;
      }

      FocusManager.instance.addListener(updateUserInputFocus);
      updateUserInputFocus();
      return () {
        FocusManager.instance.removeListener(updateUserInputFocus);
      };
    }, [controller, resizeBodyForKeyboard, toolBar]);

    final shouldHaveAppBar = helper.shouldHaveAppBar;
    final shouldHaveFloatingAppBar = helper.shouldHaveFloatingAppBar;
    final shouldHaveBottomNavBar = helper.shouldHaveBottomNavBar;
    final shouldHaveToolBar = helper.shouldHaveToolBar;
    final shouldBodyHaveBottomScaffoldSafeArea =
        helper.shouldBodyHaveBottomScaffoldSafeArea;
    final effectiveBottomNavBarHeight = helper.trueBottomNavBarHeight;
    final effectiveToolBarHeight = helper.trueToolBarHeight;
    final effectiveAppBarHeight = helper.trueAppBarHeight;
    final showDockedSideBar = helper.shouldHaveDockedSideBar;
    final showFloatingSideBar = helper.shouldHaveFloatingSideBar;
    final effectiveSideBarWidth = helper.trueSideBarWidth;
    final shouldHaveSideBarButton = helper.shouldHaveSideBarButton;
    final shouldHaveEitherFab = helper.shouldHaveEitherFab;
    final scaffoldPadding = helper.scaffoldPadding;
    final fabBottomPadding = helper.fabBottomPadding;
    final keyboardBottomInset = resizeBodyForKeyboard
        ? mediaQuery.viewInsets.bottom
        : 0.0;
    final isKeyboardOpen = keyboardBottomInset > 0;
    final toolbarViewportInset = isKeyboardOpen && shouldHaveToolBar
        ? effectiveToolBarHeight
        : 0.0;
    final contentBottomInset = keyboardBottomInset + toolbarViewportInset;
    final effectiveBottomScaffoldSafeAreaHeight =
        isKeyboardOpen && shouldHaveToolBar
        ? 0.0
        : helper.bottomScaffoldSafeAreaHeight;
    final scaffoldOverlayBottomInset = math.max(
      helper.bottomScaffoldSafeAreaHeight,
      contentBottomInset,
    );
    final scaffoldOverlayTopInset = effectiveAppBarHeight;

    final toolBarController = toolBar is ToolBar
        ? (toolBar! as ToolBar).controller
        : null;
    final bodyWithScrollLockScope = ScaffoldScrollLockScope(
      setScrollLocked: setScrollLocked,
      child: body,
    );
    final scopedBody = toolBarController == null
        ? bodyWithScrollLockScope
        : ToolBarScope(
            controller: toolBarController,
            child: bodyWithScrollLockScope,
          );
    final shouldShowUnfocusButton =
        showUnfocusButton && MediaQuery.viewInsetsOf(context).bottom <= 0;
    final effectiveScrollable = scrollable && scrollLockKeys.value.isEmpty;

    Widget innerBody = scopedBody;

    if (centeredBody) {
      innerBody = Center(child: scopedBody);
    }

    final paddedBody = Padding(
      padding: helper.contentPadding,
      child: innerBody,
    );

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
      mainAxisSize: effectiveScrollable ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (shouldHaveAppBar)
          SizedBox(height: effectiveAppBarHeight)
        else if (showViewPaddingTop)
          ViewPaddingSizedBox(side: Side.top),
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
          SizedBox(height: effectiveBottomScaffoldSafeAreaHeight)
        else if (showViewPaddingBottom && !isKeyboardOpen)
          ViewPaddingSizedBox(side: Side.bottom),
      ],
    );

    if (effectiveScrollable) {
      content = SingleChildScrollView(
        padding: EdgeInsets.zero,
        controller: scrollController,
        reverse: scrollStartAtTheBottom,
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

    if (centeredConstraint) {
      content = Align(alignment: Alignment.topCenter, child: content);
    }

    content = NotificationListener<ScrollNotification>(
      onNotification: (notification) => controller.handleScrollNotification(
        notification: notification,
        hideBottomNavigationBarOnScroll: hideBottomNavigationBarOnScroll,
        hideAppBarOnScroll: hideAppBarOnScroll,
      ),
      child: content,
    );

    final stackChildren = <Widget>[
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: contentBottomInset,
        child: content,
      ),
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
      if (shouldHaveToolBar) ...[
        Positioned(
          left: 0,
          right: 0,
          bottom: mediaQuery.viewInsets.bottom,
          child: Column(
            spacing: tokens.spaceLayoutGapSm,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (shouldShowUnfocusButton)
                Padding(
                  padding: EdgeInsets.only(right: tokens.spaceLayoutPaddingSm),
                  child: _AnimatedOverlay(
                    visible: controller.isUserInputFocusing,
                    hiddenOffset: const Offset(0, 1),
                    child: Button(
                      onPressed: FocusManager.instance.primaryFocus?.unfocus,
                      child: const Text('Unfocus Keyboard'),
                    ),
                  ),
                ),
              _AnimatedOverlay(
                visible: controller.isUserInputFocusing,
                hiddenOffset: const Offset(0, 1),
                child: SizedBox(
                  height: effectiveToolBarHeight,
                  child: toolBar!,
                ),
              ),
            ],
          ),
        ),
      ],
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
            child: SizedBox(
              height: preferredFloatingActionButtonHeight,
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
        ),
    ];

    return ScaffoldOverlayGeometry(
      topInset: scaffoldOverlayTopInset,
      bottomInset: scaffoldOverlayBottomInset,
      child: material.Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor ?? tokens.colorScaffoldBackground,
        body: Stack(clipBehavior: Clip.none, children: stackChildren),
      ),
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
