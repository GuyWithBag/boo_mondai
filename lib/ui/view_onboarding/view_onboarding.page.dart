import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BottomNavBar,
        Button,
        ButtonColor,
        Scaffold,
        StatusLayoutState;
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
                const StatusLayoutState(
                  icon: Icons.school_outlined,
                  title: 'Drills and FSRS',
                  message:
                      'Drills help you practice a deck before review. FSRS is the scheduler that learns from your answers and brings cards back when they are worth seeing again.',
                ),
                const StatusLayoutState(
                  icon: Icons.auto_awesome_outlined,
                  title: 'Welcome to BooMondai',
                  message:
                      'Build decks, study in small sessions, and let your review queue grow at a pace you can keep.',
                ),
              ],
            ),
          ),
          PageDots(index: currentPage, count: 3),
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
