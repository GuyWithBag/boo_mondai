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
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';

class ResponsiveScaffold extends HookWidget {
  final int currentIndex;
  final Widget child;

  const ResponsiveScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  static const _routes = ['/', '/online-deck-browser', '/my-decks', '/review', '/account'];
  // Indices 2 (My Decks), 3 (Review) require auth; Browse (1) is public
  static const _authRequiredIndices = {2, 3};

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAuth = auth.isAuthenticated;
    final isCreateDeck = useState(false);
    void onTap(BuildContext context, int index) {
      if (index == currentIndex) return;

      final isAuth = context.read<AuthProvider>().isAuthenticated;
      if (!isAuth && _authRequiredIndices.contains(index)) {
        // Redirect to account page to prompt login
        context.go('/account');
        return;
      }

      final goTo = _routes[index];
      context.go(goTo);
      isCreateDeck.value = goTo == '/my-decks';
    }

    FloatingActionButton? getFloatingActionButton() {
      return isCreateDeck.value
          ? FloatingActionButton(
              onPressed: () {
                context.push('/my-decks/create');
              },
              child: Icon(Icons.add_rounded),
            )
          : null;
    }

    // Group B only sees code entry — no shell nav
    if (auth.role == 'group_b_participant') {
      return Scaffold(body: child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return Scaffold(
            floatingActionButton: getFloatingActionButton(),
            body: Row(
              children: [
                NavigationRail(
                  extended: constraints.maxWidth > 1200,
                  selectedIndex: currentIndex,
                  onDestinationSelected: (i) => onTap(context, i),
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
          floatingActionButton: getFloatingActionButton(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (i) => onTap(context, i),
            destinations: _buildNavDestinations(context, isAuth),
          ),
        );
      },
    );
  }

  List<NavigationDestination> _buildNavDestinations(
    BuildContext context,
    bool isAuth,
  ) {
    final disabledColor = Theme.of(context).disabledColor;
    return [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore),
        label: 'Browse',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.library_books_outlined,
          color: isAuth ? null : disabledColor,
        ),
        selectedIcon: const Icon(Icons.library_books),
        label: 'My Decks',
      ),
      NavigationDestination(
        icon: Icon(Icons.replay_outlined, color: isAuth ? null : disabledColor),
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
      const NavigationRailDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore),
        label: Text('Browse'),
      ),
      NavigationRailDestination(
        icon: Icon(
          Icons.library_books_outlined,
          color: isAuth ? null : Colors.grey,
        ),
        selectedIcon: const Icon(Icons.library_books),
        label: Text(
          'My Decks',
          style: isAuth ? null : const TextStyle(color: Colors.grey),
        ),
        disabled: !isAuth,
      ),
      NavigationRailDestination(
        icon: Icon(Icons.replay_outlined, color: isAuth ? null : Colors.grey),
        selectedIcon: const Icon(Icons.replay),
        label: Text(
          'Review',
          style: isAuth ? null : const TextStyle(color: Colors.grey),
        ),
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
