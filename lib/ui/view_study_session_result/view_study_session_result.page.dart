// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result_page.dart
// PURPOSE: Display quiz results with score animation and FSRS review prompt
// HOOKS: useAnimationController, useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/core.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AnswerResultTile,
        AppBar,
        AppTokens,
        BottomNavBar,
        LocalDB,
        Scaffold,
        StudyRatingBreakdown,
        StudyRating,
        StudySessionSnapshot,
        Button,
        ButtonColor;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewStudySessionResultPage extends HookWidget {
  const ViewStudySessionResultPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final reviewSession = LocalDB.reviewSession.selectByPk({'id': sessionId});

    // ToDo:
    final isReviewResult = reviewSession != null;
    final tokens = context.themeTokens<AppTokens>();

    final answers =
        LocalDB.studySessionSnapshot.getBySessionId(sessionId).toList()
          ..sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    final cardAnswers = answers
        .where((snapshot) => snapshot.rating != null)
        .map(_AnswerResult.fromSnapshot)
        .toList();

    final scoreAnim = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    useEffect(() {
      scoreAnim.forward();
      return null;
    }, const []);

    void goHome() {
      context.go('/');
    }

    void goReviews() {
      context.go('/reviews');
    }

    void reviewNow() {
      // context.go('/review/${drillSession!.deckId}/session');
    }

    // ToDo:
    final enrolledCount = 0;

    final breakdown = <StudyRating, int>{
      for (final type in StudyRating.values) type: 0,
    };
    for (final a in cardAnswers) {
      breakdown[a.type] = (breakdown[a.type] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: 'Results'),
      bottomNavBar: BottomNavBar(
        child: Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            Expanded(
              child: Button(
                variants: [ButtonColor.primary],
                onPressed: isReviewResult ? goReviews : goHome,
                child: Text(
                  isReviewResult
                      ? 'Back to Reviews'
                      : enrolledCount > 0
                      ? 'Maybe Later'
                      : 'Done',
                ),
              ),
            ),
            if (!isReviewResult && enrolledCount > 0)
              Expanded(
                child: Button(
                  onPressed: reviewNow,
                  variants: [ButtonColor.primary],
                  child: const Text('Review Now'),
                ),
              ),
          ],
        ),
      ),
      body: Column(
        spacing: tokens.spaceLayoutGapMd,
        children: [
          StudyRatingBreakdown(
            animation: scoreAnim,
            breakdown: breakdown,
            total: reviewSession?.totalCards ?? 0,
          ),

          // The list of individual answers
          if (cardAnswers.isNotEmpty)
            ListingStatesWrapper.list(
              items: cardAnswers,
              useParentScroll: true,
              separatorHeight: tokens.spaceLayoutGapSm,
              itemBuilder: (context, _, answer) {
                return AnswerResultTile(
                  answerValue: answer.answerValue,
                  type: answer.type,
                  isEjected: false,
                );
              },
            )
          else
            Text('No answers recorded'),
        ],
      ),
    );
  }
}

final class _AnswerResult {
  const _AnswerResult({required this.answerValue, required this.type});

  factory _AnswerResult.fromSnapshot(StudySessionSnapshot snapshot) {
    return _AnswerResult(
      answerValue: snapshot.answer!.value,
      type: snapshot.rating!,
    );
  }

  final String answerValue;
  final StudyRating type;
}
