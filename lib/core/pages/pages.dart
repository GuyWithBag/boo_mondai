import 'package:boo_mondai/features/view_deck_downloads/view_deck_downloads.page.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppPage,
        VocabularyTestPage,
        AuthController,
        EnterResearchCodePage,
        HomePage,
        ViewDeckListingsPage,
        ViewDecksLocalPage,
        ViewStudyCardsPage,
        ViewAccountPage,
        LoginPage,
        RegisterPage,
        StudySessionPage,
        ResearcherDashboardPage,
        ViewLeaderboardPage,
        EditDeckPage,
        SessionMode,
        ViewDrillResultPage,
        PlaceholderAppPage,
        AnswerSurveyPage,
        ChangeTrackerPage,
        ChangeTrackerRouteArgs,
        SettingsPage;
import 'package:boo_mondai/features/view_cards/view_cards.page.dart'
    show ViewCardsPage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show WatchContext;

class Pages {
  static final home = AppPage(
    url: '/',
    icon: Icons.home_outlined,
    name: 'Home',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) {
          final auth = context.watch<AuthController>();
          if (auth.currentProfile.role == 'group_b_participant') {
            return const EnterResearchCodePage();
          }
          return const HomePage();
        },
  );

  static final downloads = AppPage(
    url: '/downloads',
    icon: Icons.download,
    name: 'Home',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ViewDeckDownloadsPage(),
  );

  static final decksOnline = AppPage(
    url: '/decks-online',
    icon: Icons.public_outlined,
    name: 'Browse',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ViewDeckListingsPage(),
  );

  static final decksLocal = AppPage(
    url: '/decks-local',
    icon: Icons.library_books_outlined,
    name: 'Decks',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ViewDecksLocalPage(),
  );

  static final reviews = AppPage(
    url: '/reviews',
    icon: Icons.rate_review_outlined,
    name: 'Reviews',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ViewStudyCardsPage(),
  );

  static final account = AppPage(
    url: '/account',
    icon: Icons.person_outline,
    name: 'Account',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ViewAccountPage(),
  );

  static final login = AppPage(
    url: '/login',
    name: 'Login',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const LoginPage(),
  );

  static final register = AppPage(
    url: '/register',
    name: 'Register',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const RegisterPage(),
  );

  static final editDeck = AppPage(
    url: '/decks-local/:deckId/edit',
    name: 'Edit Deck',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => EditDeckPage(
          deckId: pathParameters['deckId']!,
          initialTemplateId: queryParameters['initialTemplateId'],
        ),
  );

  static final viewCards = AppPage(
    url: '/view-cards',
    name: 'View Cards',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => ViewCardsPage(queryParameters: queryParameters),
  );

  static final drillSession = AppPage(
    url: '/drill/:deckId/session',
    name: 'Drill Session',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => StudySessionPage(
          deckId: pathParameters['deckId'],
          mode: SessionMode.drill,
        ),
  );

  static final drillResult = AppPage(
    url: '/drill/:sessionId/result',
    name: 'Drill Result',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => ViewDrillResultPage(sessionId: pathParameters['sessionId']!),
  );

  static final reviewSession = AppPage(
    url: '/review/session',
    name: 'Review Session',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const StudySessionPage(deckId: null, mode: SessionMode.review),
  );

  static final reviewDeckSession = AppPage(
    url: '/review/:deckId/session',
    name: 'Deck Review Session',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => StudySessionPage(
          deckId: pathParameters['deckId'],
          mode: SessionMode.review,
        ),
  );

  static final changeReview = AppPage(
    url: '/change-review/:serviceId/:entryId',
    name: 'Change Review',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) {
          final args = extra;
          return ChangeTrackerPage(
            args: args is ChangeTrackerRouteArgs
                ? args
                : ChangeTrackerRouteArgs.missing(
                    entryId: pathParameters['entryId']!,
                    serviceId: pathParameters['serviceId'],
                  ),
          );
        },
  );

  static final research = AppPage(
    url: '/research',
    name: 'Research',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ResearcherDashboardPage(),
  );

  static final leaderboard = AppPage(
    url: '/leaderboard',
    name: 'Leaderboard',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ViewLeaderboardPage(),
  );

  static final settings = AppPage(
    url: '/settings',
    icon: Icons.settings_outlined,
    name: 'Settings',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const SettingsPage(),
  );

  static final notifications = AppPage(
    url: '/notifications',
    icon: Icons.notifications_outlined,
    name: 'Notifications',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const PlaceholderAppPage(title: 'Notifications'),
  );

  static final privacyPolicy = AppPage(
    url: '/privacy-policy',
    icon: Icons.privacy_tip_outlined,
    name: 'Privacy Policy',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const PlaceholderAppPage(title: 'Privacy Policy'),
  );

  static final termsOfService = AppPage(
    url: '/terms-of-service',
    icon: Icons.description_outlined,
    name: 'Terms of Service',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const PlaceholderAppPage(title: 'Terms of Service'),
  );

  static final researchCode = AppPage(
    url: '/research/code',
    name: 'Research Code',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const EnterResearchCodePage(),
  );

  static final researchSurvey = AppPage(
    url: '/research/survey/:surveyType',
    name: 'Survey',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => AnswerSurveyPage(
          surveyType: pathParameters['surveyType']!,
          timePoint: queryParameters['timePoint'],
        ),
  );

  static final researchTest = AppPage(
    url: '/research/test/:testSet',
    name: 'Vocabulary Test',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => VocabularyTestPage(testSet: pathParameters['testSet']!),
  );

  static final shell = <AppPage>[
    home,
    decksOnline,
    decksLocal,
    reviews,
    account,
  ];
  static final auth = <AppPage>[login, register];
  static final appDetails = <AppPage>[
    settings,
    notifications,
    privacyPolicy,
    termsOfService,
  ];
  static final nonShell = <AppPage>[
    editDeck,
    viewCards,
    drillSession,
    drillResult,
    reviewSession,
    reviewDeckSession,
    changeReview,
    research,
    leaderboard,
    researchCode,
    researchSurvey,
    researchTest,
    downloads,
  ];
}
