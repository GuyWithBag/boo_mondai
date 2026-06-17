// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/routes.dart
// PURPOSE: go_router configuration with shell navigation (no login gate)
// PROVIDERS: AuthController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        ErrorPage,
        RouteException,
        Pages,
        MainScaffold,
        AuthService;
import 'package:go_router/go_router.dart';

GoRouter createRouter(AuthController authController) {
  return GoRouter(
    initialLocation: Pages.home.url,
    refreshListenable: authController,
    errorBuilder: (context, state) {
      final exception = RouteException(
        'Error 404: The requested page could not be found.',
        code: 'ROUTE_NOT_FOUND',
        originalError: state.error,
      );
      return ErrorPage(exception: exception);
    },
    redirect: (context, state) {
      if (state.pathParameters.isNotEmpty) {
        for (final entry in state.pathParameters.entries) {
          final value = entry.value;
          if (value.isEmpty || value == 'null') {
            throw Exception("Missing required parameter: ${entry.key}");
          }
        }
      }

      final auth = authController;
      final isAnonymous = !auth.currentProfile.isAnonymous;
      final loc = state.matchedLocation;

      if (AuthService.isAuthenticatedRemote &&
          !auth.hasPendingGuestMerge &&
          (loc == Pages.login.url || loc == Pages.register.url)) {
        return Pages.home.url;
      }

      if (loc == Pages.research.url &&
          (isAnonymous || auth.currentProfile.role != 'researcher')) {
        return Pages.home.url;
      }

      if (!isAnonymous && auth.currentProfile.role == 'group_b_participant') {
        final allowed = [
          Pages.home.url,
          Pages.researchCode.url,
          Pages.account.url,
        ];
        if (!allowed.contains(loc) &&
            !loc.startsWith('/research/survey') &&
            !loc.startsWith('/research/test')) {
          return Pages.researchCode.url;
        }
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final index = _shellIndex(state.matchedLocation);
          return MainScaffold(currentIndex: index, child: child);
        },
        routes: [
          for (final page in Pages.shell)
            GoRoute(
              path: page.url,
              builder: (context, state) => page.builder(
                context,
                pathParameters: state.pathParameters,
                queryParameters: state.uri.queryParameters,
              ),
            ),
        ],
      ),
      for (final page in Pages.auth)
        GoRoute(
          path: page.url,
          builder: (context, state) => page.builder(
            context,
            pathParameters: state.pathParameters,
            queryParameters: state.uri.queryParameters,
          ),
        ),
      for (final page in Pages.appDetails)
        GoRoute(
          path: page.url,
          builder: (context, state) => page.builder(
            context,
            pathParameters: state.pathParameters,
            queryParameters: state.uri.queryParameters,
          ),
        ),
      for (final page in Pages.nonShell)
        GoRoute(
          path: page.url,
          builder: (context, state) => page.builder(
            context,
            pathParameters: state.pathParameters,
            queryParameters: state.uri.queryParameters,
          ),
        ),
    ],
  );
}

int _shellIndex(String location) {
  for (var i = 0; i < Pages.shell.length; i++) {
    final page = Pages.shell[i];
    if (page.url == Pages.home.url) continue;
    if (location.startsWith(page.url)) return i;
  }
  return 0;
}
