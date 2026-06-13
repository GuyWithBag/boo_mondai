import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        DeckDueStats,
        DeckHistoricalStats,
        DeckReviewStats,
        ReviewDeckTile,
        createAppThemeController;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_variants/theme_variants.dart';

void main() {
  testWidgets('renders review deck stats', (tester) async {
    final themeController = createAppThemeController();

    await tester.pumpWidget(
      ThemeVariantsProvider<AppTokens>(
        controller: themeController,
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => MaterialApp(
            home: Scaffold(
              body: ReviewDeckTile(
                stats: DeckReviewStats(
                  deckId: 'deck-1',
                  deckTitle: 'Japanese Basics',
                  due: DeckDueStats(dueNew: 2, dueReview: 3),
                  historical: DeckHistoricalStats(
                    again: 1,
                    hard: 2,
                    good: 3,
                    easy: 4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Japanese Basics'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Due'), findsOneWidget);
  });
}
