// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/main_scaffold.dart
// PURPOSE: Connects routing and state to the generic Scaffold
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart' hide Scaffold;
import 'package:provider/provider.dart';
import 'package:signals_hooks/signals_hooks.dart';

class MainScaffold extends SignalHookWidget {
  final int currentIndex;
  final Widget child;

  const MainScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final hideNavigation =
        auth.currentProfile.value.role == 'group_b_participant';
    final controller = MainController.instance;
    return Scaffold(
      hideNavigation: hideNavigation,
      showBottomNavBar: controller.isBottomNavBarVisible.value,
      showAppBar: controller.isAppBarVisible.value,
      body: child,
      sidebar: SideBar(currentPageIndex: currentIndex),
      bottomNavBar: MainBottomNavBar(currentPageIndex: currentIndex),
      padding: EdgeInsets.zero,
      scrollable: false,
      safeArea: false,
      centeredConstraint: false,
      haveBottomNavBarBottomGap: false,
      shouldConstrainWidth: false,
      inheritMainBottomNavBarHeight: false,
      showViewPaddingTop: false,
      showViewPaddingBottom: false,
      resizeBodyForKeyboard: false,
      showUnfocusButton: false,
    );
  }
}
