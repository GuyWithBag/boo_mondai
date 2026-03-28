// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/routes.dart
// PURPOSE: go_router configuration with shell navigation (no login gate)
// PROVIDERS: AuthProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:go_router/go_router.dart';
import 'package:boo_mondai/pages/pages.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/widgets/widgets.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final loc = state.matchedLocation;

      // Authenticated users landing on /login or /register → go home
      if (isAuth && (loc == '/login' || loc == '/register')) return '/';

      // Auth-required routes: redirect to /account if not logged in
      if (!isAuth) {
        final requiresAuth = loc.startsWith('/my-decks') ||
            loc.startsWith('/quiz') ||
            loc.startsWith('/review') ||
            loc.startsWith('/research');
        if (requiresAuth) return '/account';
      }

      // Group B guard — redirect to code entry for non-allowed routes
      if (isAuth && authProvider.role == 'group_b_participant') {
        final allowed = ['/', '/research/code', '/account'];
        if (!allowed.contains(loc) &&
            !loc.startsWith('/research/survey') &&
            !loc.startsWith('/research/test')) {
          return '/research/code';
        }
      }

      return null;
    },
    routes: [
      // ── Shell routes (with bottom nav / rail) ─────────
      ShellRoute(
        builder: (context, state, child) {
          final index = _shellIndex(state.matchedLocation);
          return ResponsiveScaffold(
            currentIndex: index,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              if (authProvider.role == 'group_b_participant') {
                return const ResearchCodeEntryPage();
              }
              return const HomePage();
            },
          ),
          GoRoute(
            path: '/online-deck-browser',
            builder: (context, state) => const OnlineDeckBrowserPage(),
          ),
          GoRoute(
            path: '/my-decks',
            builder: (context, state) => const DeckListPage(),
          ),
          GoRoute(
            path: '/review',
            builder: (context, state) => const ReviewPage(),
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) => const AccountPage(),
          ),
        ],
      ),

      // ── Auth routes (no shell) ────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // ── Non-shell routes ──────────────────────────────
      GoRoute(
        path: '/my-decks/create',
        builder: (context, state) => const DeckCreatorPage(),
      ),
      GoRoute(
        path: '/my-decks/:deckId',
        builder: (context, state) =>
            DeckDetailPage(deckId: state.pathParameters['deckId']!),
      ),
      GoRoute(
        path: '/my-decks/:deckId/edit',
        builder: (context, state) =>
            DeckCreatorPage(deckId: state.pathParameters['deckId']),
      ),
      GoRoute(
        path: '/my-decks/:deckId/cards/edit',
        builder: (context, state) => DeckEditorPage(
          deckId: state.pathParameters['deckId']!,
          initialCardId: state.uri.queryParameters['cardId'],
        ),
      ),
      GoRoute(
        path: '/quiz/:deckId/preview',
        builder: (context, state) =>
            QuizPreviewPage(deckId: state.pathParameters['deckId']!),
      ),
      GoRoute(
        path: '/quiz/:deckId/session',
        builder: (context, state) =>
            QuizSessionPage(deckId: state.pathParameters['deckId']!),
      ),
      GoRoute(
        path: '/quiz/:sessionId/result',
        builder: (context, state) =>
            QuizResultPage(sessionId: state.pathParameters['sessionId']!),
      ),
      GoRoute(
        path: '/research',
        builder: (context, state) => const ResearcherDashboardPage(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardPage(),
      ),
      GoRoute(
        path: '/research/code',
        builder: (context, state) => const ResearchCodeEntryPage(),
      ),
      GoRoute(
        path: '/research/survey/:surveyType',
        builder: (context, state) => SurveyPage(
          surveyType: state.pathParameters['surveyType']!,
          timePoint: state.uri.queryParameters['timePoint'],
        ),
      ),
      GoRoute(
        path: '/research/test/:testSet',
        builder: (context, state) =>
            VocabularyTestPage(testSet: state.pathParameters['testSet']!),
      ),
    ],
  );
}

int _shellIndex(String location) {
  if (location.startsWith('/online-deck-browser')) return 1;
  if (location.startsWith('/my-decks')) return 2;
  if (location.startsWith('/review')) return 3;
  if (location.startsWith('/account')) return 4;
  return 0; // home
}
