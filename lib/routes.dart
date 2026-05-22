// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/routes.dart
// PURPOSE: go_router configuration with shell navigation (no login gate)
// PROVIDERS: AuthController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/exceptions/route_exception.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/pages/pages.barrel.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:provider/provider.dart';

GoRouter createRouter(AuthController authController) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authController,
    errorBuilder: (context, state) {
      // 1. Wrap the GoRouter error in your custom RouteException
      final exception = RouteException(
        'Error 404: The requested page could not be found.',
        code: 'ROUTE_NOT_FOUND',
        originalError:
            state.error, // state.error contains the actual GoRouter exception
      );

      // 2. Return a Scaffold containing your ErrorText widget
      return ErrorPage(exception: exception);
    },
    redirect: (context, state) {
      // This checks every dynamic segment (e.g., :deckId, :surveyType, :sessionId)
      if (state.pathParameters.isNotEmpty) {
        for (final entry in state.pathParameters.entries) {
          final value = entry.value;
          if (value.isEmpty || value == 'null') {
            // Throwing here sends the user straight to errorBuilder
            throw Exception("Missing required parameter: ${entry.key}");
          }
        }
      }

      final auth = authController;
      final isAnonymous = !auth.currentProfile.isAnonymous;
      final loc = state.matchedLocation;

      // Authenticated users landing on /login or /register → go home
      if (auth.service.isAuthenticatedRemote &&
          !auth.hasPendingGuestMerge &&
          (loc == '/login' || loc == '/register')) {
        return '/';
      }

      // Researcher dashboard requires a real account with the researcher role
      if (loc == '/research' &&
          (isAnonymous || auth.currentProfile.role != 'researcher')) {
        return '/';
      }

      // Group B guard — redirect to code entry for non-allowed routes
      if (!isAnonymous && auth.currentProfile.role == 'group_b_participant') {
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
          return ResponsiveScaffold(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              final auth = context.watch<AuthController>();

              if (auth.currentProfile.role == 'group_b_participant') {
                return const EnterResearchCodePage();
              }
              return const HomePage();
            },
          ),
          GoRoute(
            path: '/decks-online',
            builder: (context, state) => const ViewDecksOnlinePage(),
          ),
          GoRoute(
            path: '/decks-local',
            builder: (context, state) => const ViewDecksLocalPage(),
          ),
          GoRoute(
            path: '/reviews',
            builder: (context, state) => const ViewReviewsPage(),
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) => const ViewAccountPage(),
          ),
        ],
      ),

      // ── Auth routes (no shell) ────────────────────────
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // ── Non-shell routes ──────────────────────────────
      GoRoute(
        path: '/decks-local/create',
        builder: (context, state) => const CreateDeckPage(),
      ),
      GoRoute(
        path: '/decks-local/:deckId',
        builder: (context, state) =>
            ViewDeckLocalPage(deckId: state.pathParameters['deckId']!),
      ),
      GoRoute(
        path: '/decks-local/:deckId/edit',
        builder: (context, state) => EditDeckPage(
          deckId: state.pathParameters['deckId']!,
          initialTemplateId: state.uri.queryParameters['initialTemplateId'],
        ),
      ),
      // GoRoute(
      //   path: '/decks-local/:deckId/preview',
      //   builder: (context, state) =>
      //       DrillPreviewPage(deckId: state.pathParameters['deckId']!),
      // ),
      GoRoute(
        path: '/drill/:deckId/session',
        builder: (context, state) => StudySessionPage(
          deckId: state.pathParameters['deckId'],
          mode: SessionMode.drill,
        ),
      ),
      GoRoute(
        path: '/drill/:sessionId/result',
        builder: (context, state) =>
            ViewDrillResultPage(sessionId: state.pathParameters['sessionId']!),
      ),

      // Global Review (all due cards across all decks)
      GoRoute(
        path: '/review/session',
        builder: (context, state) =>
            const StudySessionPage(deckId: null, mode: SessionMode.review),
      ),

      // Deck-Specific Review
      GoRoute(
        path: '/review/:deckId/session',
        builder: (context, state) => StudySessionPage(
          deckId: state.pathParameters['deckId'],
          mode: SessionMode.review,
        ),
      ),
      GoRoute(
        path: '/research',
        builder: (context, state) => const ResearcherDashboardPage(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const ViewLeaderboardPage(),
      ),
      GoRoute(
        path: '/research/code',
        builder: (context, state) => const EnterResearchCodePage(),
      ),
      GoRoute(
        path: '/research/survey/:surveyType',
        builder: (context, state) => AnswerSurveyPage(
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
  if (location.startsWith('/decks-online')) return 1;
  if (location.startsWith('/decks-local')) return 2;
  if (location.startsWith('/review')) return 3;
  if (location.startsWith('/account')) return 4;
  return 0; // home
}
