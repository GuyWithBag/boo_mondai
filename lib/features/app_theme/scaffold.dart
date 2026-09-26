import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        MainController,
        ScaffoldController,
        ScaffoldRefreshBuilder,
        ScaffoldOverlayGeometry,
        ScaffoldScrollLockScope,
        ToolBar,
        ToolBarScope,
        ViewPaddingSizedBox,
        Side;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter/material.dart' as material show Scaffold;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart' show ReadContext;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class Scaffold extends SignalHookWidget {
  const Scaffold({
    super.key,
    required this.body,
    this.hideNavigation = false,
    this.showBottomNavBar = true,
    this.showAppBar = true,
    this.isFloatingSideBar = false,
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
    this.onRefresh,
    this.refreshBuilder,
  }) : assert(sidebarWidth >= 0, 'sidebarWidth cannot be negative.'),
       assert(
         onRefresh == null || scrollable,
         'onRefresh requires scrollable to be true.',
       );

  final Widget body;
  final bool hideNavigation;
  final bool showBottomNavBar;
  final bool showAppBar;
  final bool isFloatingSideBar;
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
  final RefreshCallback? onRefresh;
  final ScaffoldRefreshBuilder? refreshBuilder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final mediaQuery = MediaQuery.of(context);
    final mainController = context.read<MainController>();
    final controller = useMemoized(
      () => ScaffoldController(
        tokens: tokens,
        mediaQuery: mediaQuery,
        mainController: mainController,
        appBar: appBar,
        sidebar: sidebar,
        sidebarWidth: sidebarWidth,
        bottomNavBar: bottomNavBar,
        toolBar: toolBar,
        padding: padding,
        hideNavigation: hideNavigation,
        floatingActionButton: floatingActionButton,
        preferredFloatingActionButtonHeight:
            preferredFloatingActionButtonHeight,
        hideAppBarOnScroll: hideAppBarOnScroll,
        hideBottomNavigationBarOnScroll: hideBottomNavigationBarOnScroll,
        hideFloatingActionButtonOnScroll: hideFloatingActionButtonOnScroll,
        isFloatingAppBar: isFloatingAppBar,
        haveSideBarOpenButton: haveSideBarOpenButton,
        haveBottomNavBarBottomGap: haveBottomNavBarBottomGap,
        inheritMainBottomNavBarHeight: inheritMainBottomNavBarHeight,
        resizeBodyForKeyboard: resizeBodyForKeyboard,
        scrollable: scrollable,
        showUnfocusButton: showUnfocusButton,
        showViewPaddingBottom: showViewPaddingBottom,
        showViewPaddingTop: showViewPaddingTop,
        centeredConstraint: centeredConstraint,
        centeredBody: centeredBody,
        shouldConstrainWidth: shouldConstrainWidth,
        safeArea: safeArea,
        maxWidth: maxWidth,
        onRefresh: onRefresh,
        refreshBuilder: refreshBuilder,
        scrollStartAtTheBottom: scrollStartAtTheBottom,
        scrollController: scrollController,
        initialShowBottomNavBar: showBottomNavBar,
        initialShowAppBar: showAppBar,
        initialIsFloatingSideBar: isFloatingSideBar,
        initialFloatingSideBarInitiallyOpen: floatingSideBarInitiallyOpen,
      ),
      [
        tokens,
        mediaQuery,
        mainController,
        appBar,
        sidebar,
        sidebarWidth,
        bottomNavBar,
        toolBar,
        padding,
        hideNavigation,
        showBottomNavBar,
        showAppBar,
        isFloatingSideBar,
        floatingActionButton,
        preferredFloatingActionButtonHeight,
        hideAppBarOnScroll,
        hideBottomNavigationBarOnScroll,
        hideFloatingActionButtonOnScroll,
        isFloatingAppBar,
        haveSideBarOpenButton,
        haveBottomNavBarBottomGap,
        inheritMainBottomNavBarHeight,
        resizeBodyForKeyboard,
        scrollable,
        showUnfocusButton,
        showViewPaddingBottom,
        showViewPaddingTop,
        centeredConstraint,
        centeredBody,
        shouldConstrainWidth,
        safeArea,
        maxWidth,
        onRefresh,
        refreshBuilder,
        scrollStartAtTheBottom,
        scrollController,
        floatingSideBarInitiallyOpen,
      ],
    );

    useEffect(() => controller.dispose, [controller]);

    useEffect(() {
      if (toolBar == null && !resizeBodyForKeyboard) {
        controller.isUserInputFocusing.value = false;
        return null;
      }

      controller.addFocusListener();
      return controller.removeFocusListener;
    }, [controller, resizeBodyForKeyboard, toolBar]);

    final shouldHaveAppBar = controller.shouldHaveAppBar.value;
    final shouldHaveFloatingAppBar = controller.shouldHaveFloatingAppBar.value;
    final shouldHaveBottomNavBar = controller.shouldHaveBottomNavBar.value;
    final shouldHaveToolBar = controller.shouldHaveToolBar.value;
    final shouldBodyHaveBottomScaffoldSafeArea =
        controller.shouldBodyHaveBottomScaffoldSafeArea.value;
    final effectiveBottomNavBarHeight = controller.trueBottomNavBarHeight.value;
    final effectiveToolBarHeight = controller.trueToolBarHeight.value;
    final effectiveAppBarHeight = controller.trueAppBarHeight.value;
    final showDockedSideBar = controller.shouldHaveDockedSideBar.value;
    final showFloatingSideBar = controller.shouldHaveFloatingSideBar.value;
    final effectiveSideBarWidth = controller.trueSideBarWidth.value;
    final shouldHaveSideBarButton = controller.shouldHaveSideBarButton.value;
    final shouldHaveEitherFab = controller.shouldHaveEitherFab.value;
    final scaffoldPadding = controller.scaffoldPadding.value;
    final fabBottomPadding = controller.fabBottomPadding.value;
    final isKeyboardOpen = controller.isKeyboardOpen.value;
    final contentBottomInset = controller.contentBottomInset.value;
    final effectiveBottomScaffoldSafeAreaHeight =
        controller.effectiveBottomScaffoldSafeAreaHeight.value;
    final scaffoldOverlayBottomInset =
        controller.scaffoldOverlayBottomInset.value;
    final scaffoldOverlayTopInset = effectiveAppBarHeight;

    final toolBarController = toolBar is ToolBar
        ? (toolBar! as ToolBar).controller
        : null;
    final bodyWithScrollLockScope = ScaffoldScrollLockScope(
      setScrollLocked: controller.setScrollLockedCallback,
      child: body,
    );
    final scopedBody = toolBarController == null
        ? bodyWithScrollLockScope
        : ToolBarScope(
            controller: toolBarController,
            child: bodyWithScrollLockScope,
          );
    final shouldShowUnfocusButton = controller.shouldShowUnfocusButton.value;
    final effectiveScrollable = controller.effectiveScrollable.value;

    Widget innerBody = scopedBody;

    if (centeredBody) {
      innerBody = Center(child: scopedBody);
    }
    final paddedBody = Padding(
      padding: controller.contentPadding.value,
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
                  child: AnimatedOverlay(
                    visible: controller.isEitherAppBarVisible.value,
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

    final effectiveOnRefresh = controller.onRefresh;

    if (effectiveScrollable) {
      content = SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: effectiveOnRefresh == null
            ? null
            : const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        reverse: scrollStartAtTheBottom,
        child: content,
      );
    }

    if (effectiveOnRefresh != null && effectiveScrollable) {
      content =
          controller.refreshBuilder?.call(
            context,
            effectiveOnRefresh,
            content,
          ) ??
          RefreshIndicator(onRefresh: effectiveOnRefresh, child: content);
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
      onNotification: controller.handleScrollNotification,
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
        AnimatedOverlay(
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
          child: AnimatedOverlay(
            visible: controller.isEitherAppBarVisible.value,
            hiddenOffset: const Offset(0, -1),
            child: SizedBox(height: effectiveAppBarHeight, child: appBar!),
          ),
        ),
      if (shouldHaveBottomNavBar)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedOverlay(
            visible: controller.isBottomNavBarVisible.value,
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
                  child: AnimatedOverlay(
                    visible: controller.isUserInputFocusing.value,
                    hiddenOffset: const Offset(0, 1),
                    child: Button(
                      onPressed: FocusManager.instance.primaryFocus?.unfocus,
                      child: const Text('Unfocus Keyboard'),
                    ),
                  ),
                ),
              AnimatedOverlay(
                visible: controller.isUserInputFocusing.value,
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
            ignoring: !controller.isSideBarVisible.value,
            child: AnimatedOpacity(
              opacity: controller.isSideBarVisible.value ? 1 : 0,
              duration: ScaffoldController.animationDuration,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => controller.isSideBarVisible.value = false,
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.24),
                      ),
                    ),
                  ),
                  AnimatedOverlay(
                    visible: controller.isSideBarVisible.value,
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
          child: AnimatedOverlay(
            visible: controller.isEitherFabVisible.value,
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

class AnimatedOverlay extends HookWidget {
  const AnimatedOverlay({
    super.key,
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
            duration: ScaffoldController.animationDuration,
            curve: Curves.easeOutCubic,
            begin: 0,
            end: 1,
          )
          .slide(
            duration: ScaffoldController.animationDuration,
            curve: Curves.easeOutCubic,
            begin: hiddenOffset,
            end: Offset.zero,
          ),
    );
  }
}
