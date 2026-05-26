import 'package:boo_mondai/lib.barrel.dart'
    show
        AppPage,
        VocabularyTestPage,
        AuthController,
        EnterResearchCodePage,
        HomePage,
        ViewDecksOnlinePage,
        ViewDecksLocalPage,
        ViewReviewsPage,
        ViewAccountPage,
        VariantShowcasePage,
        LoginPage,
        RegisterPage,
        CreateDeckPage,
        StudySessionPage,
        ResearcherDashboardPage,
        ViewLeaderboardPage,
        ViewDeckLocalPage,
        EditDeckPage,
        SessionMode,
        ViewDrillResultPage,
        AnswerSurveyPage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show WatchContext;

class Pages {
  static final home = AppPage(
    url: '/',
    icon: const Icon(Icons.home_outlined),
    name: const Text('Home'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) {
          final auth = context.watch<AuthController>();
          if (auth.currentProfile.role == 'group_b_participant') {
            return const EnterResearchCodePage();
          }
          return const HomePage();
        },
  );

  static final decksOnline = AppPage(
    url: '/decks-online',
    icon: const Icon(Icons.public_outlined),
    name: const Text('Decks Online'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewDecksOnlinePage(),
  );

  static final decksLocal = AppPage(
    url: '/decks-local',
    icon: const Icon(Icons.library_books_outlined),
    name: const Text('Decks Local'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewDecksLocalPage(),
  );

  static final reviews = AppPage(
    url: '/reviews',
    icon: const Icon(Icons.rate_review_outlined),
    name: const Text('Reviews'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewReviewsPage(),
  );

  static final account = AppPage(
    url: '/account',
    icon: const Icon(Icons.person_outline),
    name: const Text('Account'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewAccountPage(),
  );

  static final variants = AppPage(
    url: '/variants',
    icon: const Icon(Icons.palette_outlined),
    name: const Text('Variants'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const VariantShowcasePage(),
  );

  static final login = AppPage(
    url: '/login',
    icon: const SizedBox.shrink(),
    name: const Text('Login'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const LoginPage(),
  );

  static final register = AppPage(
    url: '/register',
    icon: const SizedBox.shrink(),
    name: const Text('Register'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const RegisterPage(),
  );

  static final createDeck = AppPage(
    url: '/decks-local/create',
    icon: const SizedBox.shrink(),
    name: const Text('Create Deck'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const CreateDeckPage(),
  );

  static final viewDeckLocal = AppPage(
    url: '/decks-local/:deckId',
    icon: const SizedBox.shrink(),
    name: const Text('Deck'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            ViewDeckLocalPage(deckId: pathParameters['deckId']!),
  );

  static final editDeck = AppPage(
    url: '/decks-local/:deckId/edit',
    icon: const SizedBox.shrink(),
    name: const Text('Edit Deck'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            EditDeckPage(
              deckId: pathParameters['deckId']!,
              initialTemplateId: queryParameters['initialTemplateId'],
            ),
  );

  static final drillSession = AppPage(
    url: '/drill/:deckId/session',
    icon: const SizedBox.shrink(),
    name: const Text('Drill Session'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            StudySessionPage(
              deckId: pathParameters['deckId'],
              mode: SessionMode.drill,
            ),
  );

  static final drillResult = AppPage(
    url: '/drill/:sessionId/result',
    icon: const SizedBox.shrink(),
    name: const Text('Drill Result'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            ViewDrillResultPage(sessionId: pathParameters['sessionId']!),
  );

  static final reviewSession = AppPage(
    url: '/review/session',
    icon: const SizedBox.shrink(),
    name: const Text('Review Session'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const StudySessionPage(deckId: null, mode: SessionMode.review),
  );

  static final reviewDeckSession = AppPage(
    url: '/review/:deckId/session',
    icon: const SizedBox.shrink(),
    name: const Text('Deck Review Session'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            StudySessionPage(
              deckId: pathParameters['deckId'],
              mode: SessionMode.review,
            ),
  );

  static final research = AppPage(
    url: '/research',
    icon: const SizedBox.shrink(),
    name: const Text('Research'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ResearcherDashboardPage(),
  );

  static final leaderboard = AppPage(
    url: '/leaderboard',
    icon: const SizedBox.shrink(),
    name: const Text('Leaderboard'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewLeaderboardPage(),
  );

  static final researchCode = AppPage(
    url: '/research/code',
    icon: const SizedBox.shrink(),
    name: const Text('Research Code'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const EnterResearchCodePage(),
  );

  static final researchSurvey = AppPage(
    url: '/research/survey/:surveyType',
    icon: const SizedBox.shrink(),
    name: const Text('Survey'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            AnswerSurveyPage(
              surveyType: pathParameters['surveyType']!,
              timePoint: queryParameters['timePoint'],
            ),
  );

  static final researchTest = AppPage(
    url: '/research/test/:testSet',
    icon: const SizedBox.shrink(),
    name: const Text('Vocabulary Test'),
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            VocabularyTestPage(testSet: pathParameters['testSet']!),
  );

  static final shell = <AppPage>[
    home,
    decksOnline,
    decksLocal,
    reviews,
    account,
    variants,
  ];
  static final auth = <AppPage>[login, register];
  static final nonShell = <AppPage>[
    createDeck,
    viewDeckLocal,
    editDeck,
    drillSession,
    drillResult,
    reviewSession,
    reviewDeckSession,
    research,
    leaderboard,
    researchCode,
    researchSurvey,
    researchTest,
  ];
}
