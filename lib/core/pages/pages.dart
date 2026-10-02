import 'package:boo_mondai/lib.barrel.dart'
    show
        AppPage,
        HomePage,
        ViewDeckListingsPage,
        ViewDecksLocalPage,
        ViewStudyDecksPage,
        ViewProfilePage,
        LoginPage,
        RegisterPage,
        ViewStudySessionPage,
        ViewLeaderboardPage,
        EditDeckPage,
        SessionMode,
        ViewStudySessionResultPage,
        PlaceholderAppPage,
        ChangeTrackerPage,
        ChangeTrackerRouteArgs,
        SettingsPage,
        ResearcherDashboardPage,
        ResearcherSurveyDetailPage,
        ResearcherSurveyResponsePage,
        ViewSurveyPage,
        ViewDeckDownloadsPage,
        ViewCardsPage,
        ViewCardSinglePage,
        ViewNotificationIntentPage,
        CardTemplate,
        ChangeTrackerController;
import 'package:boo_mondai/ui/view_onboarding/view_onboarding.page.dart';

import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';

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
        }) => const ViewStudyDecksPage(),
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
        }) => const ViewProfilePage(),
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

  static final onboarding = AppPage(
    url: '/onboarding',
    name: 'Onboarding',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ViewOnboardingPage(),
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

  static final viewCardSingle = AppPage(
    url: '/cards/:templateId/preview',
    name: 'Card Preview',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => ViewCardSinglePage(
          templateId: pathParameters['templateId']!,
          initialTemplate: extra is CardTemplate ? extra : null,
        ),
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
        }) => ViewStudySessionPage(
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
        }) =>
            ViewStudySessionResultPage(sessionId: pathParameters['sessionId']!),
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
        }) =>
            const ViewStudySessionPage(deckId: null, mode: SessionMode.review),
  );

  static final reviewResult = AppPage(
    url: '/review/:sessionId/result',
    name: 'Review Result',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) =>
            ViewStudySessionResultPage(sessionId: pathParameters['sessionId']!),
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
        }) => ViewStudySessionPage(
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
            controller: ChangeTrackerController(
              pageArgs: signal(
                args is ChangeTrackerRouteArgs
                    ? args
                    : ChangeTrackerRouteArgs.missing(
                        entryId: pathParameters['entryId']!,
                        serviceId: pathParameters['serviceId'],
                      ),
              ),
            ),
          );
        },
  );

  static final viewSurvey = AppPage(
    url: '/view-survey/:surveyId',
    name: 'Survey',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => ViewSurveyPage(surveyId: pathParameters['surveyId']!),
  );

  static final researcherDashboard = AppPage(
    url: '/researcher-dashboard',
    icon: Icons.science_outlined,
    name: 'Researcher Dashboard',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => const ResearcherDashboardPage(),
  );

  static final researcherSurvey = AppPage(
    url: '/researcher-dashboard/surveys/:surveyId',
    icon: Icons.analytics_outlined,
    name: 'Survey Data',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => ResearcherSurveyDetailPage(surveyId: pathParameters['surveyId']!),
  );

  static final researcherSurveyResponse = AppPage(
    url: '/researcher-dashboard/surveys/:surveyId/responses/:responseId',
    icon: Icons.assignment_turned_in_outlined,
    name: 'Survey Response',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => ResearcherSurveyResponsePage(
          surveyId: pathParameters['surveyId']!,
          responseId: pathParameters['responseId']!,
        ),
  );

  static String researcherSurveyUrl(String surveyId) {
    return '/researcher-dashboard/surveys/$surveyId';
  }

  static String researcherSurveyResponseUrl(
    String surveyId,
    String responseId,
  ) {
    return '/researcher-dashboard/surveys/$surveyId/responses/$responseId';
  }

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

  static final viewNotificationIntent = AppPage(
    url: '/view-notification-intent/:id',
    icon: Icons.notifications_outlined,
    name: 'Notification',
    builder:
        (
          context, {
          pathParameters = const {},
          queryParameters = const {},
          extra,
        }) => ViewNotificationIntentPage(id: int.parse(pathParameters['id']!)),
  );

  static String notificationIntentUrl(int id) =>
      '/view-notification-intent/$id';

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
    onboarding,
    editDeck,
    viewCards,
    viewCardSingle,
    drillSession,
    drillResult,
    reviewSession,
    reviewResult,
    reviewDeckSession,
    changeReview,
    viewNotificationIntent,
    viewSurvey,
    researcherDashboard,
    researcherSurveyResponse,
    researcherSurvey,
    leaderboard,
    downloads,
  ];
}
