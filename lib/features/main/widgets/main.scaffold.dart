// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/main_scaffold.dart
// PURPOSE: Connects routing and state to the generic PageScaffold
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
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

    return PageScaffold(
      body: child,
      hideNavigation: hideNavigation,
      hideBottomNavigationBarOnScroll: true,
      sidebar: Sidebar(currentPageIndex: currentIndex),
      bottomNavigationBar: BottomNavbar(currentPageIndex: currentIndex),
      padding: EdgeInsets.zero,
      scrollable: false,
      safeArea: false,
      center: false,
      constrainWidth: false,
    );
  }
}
