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
    icon: Icons.home_outlined,
    name: 'Home',
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
    icon: Icons.public_outlined,
    name: 'Decks Online',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewDecksOnlinePage(),
  );

  static final decksLocal = AppPage(
    url: '/decks-local',
    icon: Icons.library_books_outlined,
    name: 'Decks Local',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewDecksLocalPage(),
  );

  static final reviews = AppPage(
    url: '/reviews',
    icon: Icons.rate_review_outlined,
    name: 'Reviews',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewReviewsPage(),
  );

  static final account = AppPage(
    url: '/account',
    icon: Icons.person_outline,
    name: 'Account',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewAccountPage(),
  );

  static final variants = AppPage(
    url: '/variants',
    icon: Icons.palette_outlined,
    name: 'Variants',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const VariantShowcasePage(),
  );

  static final login = AppPage(
    url: '/login',
    name: 'Login',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const LoginPage(),
  );

  static final register = AppPage(
    url: '/register',
    name: 'Register',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const RegisterPage(),
  );

  static final createDeck = AppPage(
    url: '/decks-local/create',
    name: 'Create Deck',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const CreateDeckPage(),
  );

  static final viewDeckLocal = AppPage(
    url: '/decks-local/:deckId',
    name: 'Deck',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            ViewDeckLocalPage(deckId: pathParameters['deckId']!),
  );

  static final editDeck = AppPage(
    url: '/decks-local/:deckId/edit',
    name: 'Edit Deck',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            EditDeckPage(
              deckId: pathParameters['deckId']!,
              initialTemplateId: queryParameters['initialTemplateId'],
            ),
  );

  static final drillSession = AppPage(
    url: '/drill/:deckId/session',
    name: 'Drill Session',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            StudySessionPage(
              deckId: pathParameters['deckId'],
              mode: SessionMode.drill,
            ),
  );

  static final drillResult = AppPage(
    url: '/drill/:sessionId/result',
    name: 'Drill Result',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            ViewDrillResultPage(sessionId: pathParameters['sessionId']!),
  );

  static final reviewSession = AppPage(
    url: '/review/session',
    name: 'Review Session',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const StudySessionPage(deckId: null, mode: SessionMode.review),
  );

  static final reviewDeckSession = AppPage(
    url: '/review/:deckId/session',
    name: 'Deck Review Session',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            StudySessionPage(
              deckId: pathParameters['deckId'],
              mode: SessionMode.review,
            ),
  );

  static final research = AppPage(
    url: '/research',
    name: 'Research',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ResearcherDashboardPage(),
  );

  static final leaderboard = AppPage(
    url: '/leaderboard',
    name: 'Leaderboard',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const ViewLeaderboardPage(),
  );

  static final researchCode = AppPage(
    url: '/research/code',
    name: 'Research Code',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            const EnterResearchCodePage(),
  );

  static final researchSurvey = AppPage(
    url: '/research/survey/:surveyType',
    name: 'Survey',
    builder:
        (context, {pathParameters = const {}, queryParameters = const {}}) =>
            AnswerSurveyPage(
              surveyType: pathParameters['surveyType']!,
              timePoint: queryParameters['timePoint'],
            ),
  );

  static final researchTest = AppPage(
    url: '/research/test/:testSet',
    name: 'Vocabulary Test',
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
