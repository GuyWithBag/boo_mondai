import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BottomNavBar,
        Button,
        ButtonColor,
        MarkdownText,
        MarkdownTextMode,
        RatingButton,
        Scaffold,
        StatusLayoutState,
        StudyRating,
        StudySessionConfig,
        StudySessionController,
        TextSize,
        TextWeight,
        textStyle;
import 'package:boo_mondai/ui/view_onboarding/view_onboarding.controller.dart';
import 'package:boo_mondai/ui/view_onboarding/widgets/page_dots.dart';
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewOnboardingPage extends SignalHookWidget {
  const ViewOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(() => ViewOnboardingController());
    useEffect(() => controller.dispose, [controller]);

    final tokens = context.themeTokens<AppTokens>();
    final ratingDemoController = useMemoized(
      () => StudySessionController(
        config: const StudySessionConfig.spacedRepitition(),
      ),
    );
    useEffect(() => ratingDemoController.dispose, [ratingDemoController]);
    final currentPage = controller.currentPage.value;
    final isRequestingNotifications =
        controller.isRequestingNotifications.value;

    return Scaffold(
      scrollable: false,
      showAppBar: true,
      centeredBody: true,
      padding: EdgeInsets.all(tokens.spaceLayoutGapLg),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.setCurrentPage,
              children: [
                StatusLayoutState(
                  icon: Icons.notifications_active_outlined,
                  title: 'Enable notifications',
                  message:
                      'BooMondai can remind you when cards are ready to review, so study stays light and consistent.',
                  actions: [
                    Button(
                      variants: [ButtonColor.primary],
                      onPressed: isRequestingNotifications
                          ? null
                          : () => controller.requestNotifications(context),
                      leading: const Icon(Icons.notifications_outlined),
                      child: Text(
                        isRequestingNotifications ? 'Opening...' : 'Allow',
                      ),
                    ),
                  ],
                ),
                _buildMarkdownStatusPage(
                  context: context,
                  icon: Icons.school_outlined,
                  title: 'Drills and FSRS Review',
                  markdown:
                      '## Drills are for first practice\n they help you memorize cards in the short term.\n\n## FSRS is the spaced repitition review scheduler for long term memorization\n After you rate a card, it estimates how stable that memory is and chooses when the card should return. Easy cards wait longer; shaky cards come back sooner.',
                ),
                _buildRatingTooltipPage(
                  context: context,
                  ratingDemoController: ratingDemoController,
                ),
                _buildMarkdownStatusPage(
                  context: context,
                  icon: Icons.auto_awesome_outlined,
                  title: 'Are you ready?',
                  markdown:
                      '**Welome to BooMondai!**\n\nStart creating decks and your first cards to start your memorizing journey!',
                ),
              ],
            ),
          ),
          PageDots(index: currentPage, count: 4),
        ],
      ),
      bottomNavBar: BottomNavBar(
        child: Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            Expanded(
              child: Button(
                onPressed: currentPage == 0 ? null : controller.goBack,
                child: const Text('Back'),
              ),
            ),

            Expanded(
              child: Button(
                variants: [ButtonColor.primary],
                onPressed: () => controller.goNext(context),
                child: Text(
                  currentPage == ViewOnboardingController.lastPageIndex
                      ? 'Start'
                      : 'Next',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMarkdownStatusPage({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String markdown,
}) {
  final tokens = context.themeTokens<AppTokens>();

  return Center(
    child: SingleChildScrollView(
      child: Column(
        spacing: tokens.spaceLayoutGapSm,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: tokens.colorTextMuted),
          SelectableText(
            title,
            textAlign: TextAlign.center,
            style: textStyle.resolve(tokens, const [
              TextSize.header2,
              TextWeight.strong,
            ]),
          ),
          MarkdownText(
            data: markdown,
            fitContent: false,
            mode: MarkdownTextMode.previewSelectable,
            defaultMarkdownAlignment: WrapAlignment.center,
            baseTextStyle: textStyle.resolve(tokens, const [
              TextSize.label,
              TextWeight.body,
            ]),
          ),
        ],
      ),
    ),
  );
}

Widget _buildRatingTooltipPage({
  required BuildContext context,
  required StudySessionController ratingDemoController,
}) {
  final tokens = context.themeTokens<AppTokens>();

  return Center(
    child: SingleChildScrollView(
      child: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 56,
            color: tokens.colorTextMuted,
          ),
          SelectableText(
            'Hold for help',
            textAlign: TextAlign.center,
            style: textStyle.resolve(tokens, const [
              TextSize.header2,
              TextWeight.strong,
            ]),
          ),
          MarkdownText(
            data:
                '**Press and hold** a button to view what it does.\n\nMost buttons work this way, so when you are having problems understanding what it does, *just press and hold!*',
            mode: MarkdownTextMode.previewSelectable,
            defaultMarkdownAlignment: WrapAlignment.center,
            baseTextStyle: textStyle.resolve(tokens, const [
              TextSize.label,
              TextWeight.body,
            ]),
          ),
          Row(
            spacing: tokens.spaceLayoutGapSm,
            children: [
              RatingButton(
                StudyRating.again,
                ctrl: ratingDemoController,
                onTap: () {},
              ),
              RatingButton(
                StudyRating.hard,
                ctrl: ratingDemoController,
                onTap: () {},
              ),
              RatingButton(
                StudyRating.good,
                ctrl: ratingDemoController,
                onTap: () {},
              ),
              RatingButton(
                StudyRating.easy,
                ctrl: ratingDemoController,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
