// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/responsive_scaffold.dart
// PURPOSE: Responsive shell — mobile bottom nav, desktop navigation rail
// PROVIDERS: AuthProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/shared/breakpoints.dart';

class ResponsiveScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const ResponsiveScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  static const _routes = ['/', '/decks', '/review', '/account'];

  // Indices 1 (Decks) and 2 (Review) require auth
  static const _authRequiredIndices = {1, 2};

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    final isAuth = context.read<AuthProvider>().isAuthenticated;
    if (!isAuth && _authRequiredIndices.contains(index)) {
      // Redirect to account page to prompt login
      context.go('/account');
      return;
    }

    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAuth = auth.isAuthenticated;

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
                  onDestinationSelected: (i) => _onTap(context, i),
                  destinations: _buildRailDestinations(isAuth),
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
            onDestinationSelected: (i) => _onTap(context, i),
            destinations: _buildNavDestinations(context, isAuth),
          ),
        );
      },
    );
  }

  List<NavigationDestination> _buildNavDestinations(
      BuildContext context, bool isAuth) {
    final disabledColor = Theme.of(context).disabledColor;
    return [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.library_books_outlined,
            color: isAuth ? null : disabledColor),
        selectedIcon: const Icon(Icons.library_books),
        label: 'Decks',
      ),
      NavigationDestination(
        icon:
            Icon(Icons.replay_outlined, color: isAuth ? null : disabledColor),
        selectedIcon: const Icon(Icons.replay),
        label: 'Review',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outlined),
        selectedIcon: Icon(Icons.person),
        label: 'Account',
      ),
    ];
  }

  List<NavigationRailDestination> _buildRailDestinations(bool isAuth) {
    return [
      const NavigationRailDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: Text('Home'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.library_books_outlined,
            color: isAuth ? null : Colors.grey),
        selectedIcon: const Icon(Icons.library_books),
        label: Text('Decks',
            style: isAuth ? null : const TextStyle(color: Colors.grey)),
        disabled: !isAuth,
      ),
      NavigationRailDestination(
        icon:
            Icon(Icons.replay_outlined, color: isAuth ? null : Colors.grey),
        selectedIcon: const Icon(Icons.replay),
        label: Text('Review',
            style: isAuth ? null : const TextStyle(color: Colors.grey)),
        disabled: !isAuth,
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.person_outlined),
        selectedIcon: Icon(Icons.person),
        label: Text('Account'),
      ),
    ];
  }
}
