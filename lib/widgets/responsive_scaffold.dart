// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/responsive_scaffold.dart
// PURPOSE: Responsive shell — mobile bottom nav, desktop navigation rail
// PROVIDERS: AuthProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class ResponsiveScaffold extends HookWidget {
  final int currentIndex;
  final Widget child;

  const ResponsiveScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  static const _routes = [
    '/',
    '/online-deck-browser',
    '/my-decks',
    '/review',
    '/account',
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isCreateDeck = useState(false);

    void onTap(BuildContext context, int index) {
      if (index == currentIndex) return;
      final goTo = _routes[index];
      context.go(goTo);
      isCreateDeck.value = goTo == '/my-decks';
    }

    // Group B only sees code entry — no shell nav
    if (auth.role == 'group_b_participant') {
      return Scaffold(body: child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: constraints.maxWidth > 1200,
                  selectedIndex: currentIndex,
                  onDestinationSelected: (i) => onTap(context, i),
                  destinations: _buildRailDestinations(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (i) => onTap(context, i),
            destinations: _buildNavDestinations(),
          ),
        );
      },
    );
  }

  List<NavigationDestination> _buildNavDestinations() {
    return const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore),
        label: 'Browse',
      ),
      NavigationDestination(
        icon: Icon(Icons.library_books_outlined),
        selectedIcon: Icon(Icons.library_books),
        label: 'My Decks',
      ),
      NavigationDestination(
        icon: Icon(Icons.replay_outlined),
        selectedIcon: Icon(Icons.replay),
        label: 'Review',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outlined),
        selectedIcon: Icon(Icons.person),
        label: 'Account',
      ),
    ];
  }

  List<NavigationRailDestination> _buildRailDestinations() {
    return const [
      NavigationRailDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: Text('Home'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore),
        label: Text('Browse'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.library_books_outlined),
        selectedIcon: Icon(Icons.library_books),
        label: Text('My Decks'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.replay_outlined),
        selectedIcon: Icon(Icons.replay),
        label: Text('Review'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.person_outlined),
        selectedIcon: Icon(Icons.person),
        label: Text('Account'),
      ),
    ];
  }
}
