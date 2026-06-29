// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/main_scaffold.dart
// PURPOSE: Connects routing and state to the generic Scaffold
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart' hide Scaffold;
import 'package:provider/provider.dart';

class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const MainScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final hideNavigation = auth.currentProfile.role == 'group_b_participant';
    final controller = context.watch<MainController>();

    return Scaffold(
      body: child,
      hideNavigation: hideNavigation,
      sidebar: SideBar(currentPageIndex: currentIndex),
      bottomNavBar: MainBottomNavBar(currentPageIndex: currentIndex),
      padding: EdgeInsets.zero,
      scrollable: false,
      safeArea: false,
      center: false,
      haveBottomNavBarBottomGap: false,
      shouldConstrainWidth: false,
      inheritMainBottomNavBarHeight: false,
      showBottomNavBar: controller.isBottomNavBarVisible,
      showAppBar: controller.isAppBarVisible,
    );
  }
}
