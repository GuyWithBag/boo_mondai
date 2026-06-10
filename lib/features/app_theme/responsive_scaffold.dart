// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/responsive_scaffold.dart
// PURPOSE: Generic Responsive shell — mobile bottom nav, desktop navigation rail
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show Breakpoints;
import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final Widget sidebar;
  final PreferredSizeWidget? appbar;
  final Widget bottomNavbar;
  final bool hideNavigation;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    required this.sidebar,
    required this.bottomNavbar,
    this.appbar,
    this.hideNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    // If navigation is hidden (e.g., for your Group B participants),
    // just return the raw scaffold with the child and optional appbar.
    if (hideNavigation) {
      return Scaffold(appBar: appbar, body: child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        // Desktop Layout: Sidebar on the left, child on the right
        if (!Breakpoints.isMobile(size)) {
          return Scaffold(
            appBar: appbar,
            body: Row(
              children: [
                sidebar,
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        // Mobile Layout: Standard bottom navigation
        return Scaffold(
          appBar: appbar,
          body: child,
          bottomNavigationBar: bottomNavbar,
        );
      },
    );
  }
}
