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
        ErrorText,
        LocalDB,
        Scaffold,
        StudyRatingBreakdown,
        StudyRating,
        StudySessionStepRecord,
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
    final drillSession = LocalDB.drillSession.selectByPk({'id': sessionId});
    final reviewSession = drillSession == null
        ? LocalDB.reviewSession.selectByPk({'id': sessionId})
        : null;
    final isReviewResult = reviewSession != null;
    final tokens = context.themeTokens<AppTokens>();

    if (drillSession == null && reviewSession == null) {
      return Scaffold(
        body: Center(
          child: ErrorText(Exception('Study session result was not found.')),
        ),
      );
    }

    final answers = isReviewResult
        ? LocalDB.studySessionStepRecord
              .getBySessionId(sessionId)
              .map(_AnswerResult.fromStepRecord)
              .toList()
        : LocalDB.drillAnswer
              .getBySessionId(sessionId)
              .map(
                (answer) => _AnswerResult(
                  userAnswer: answer.userAnswer,
                  type: answer.type,
                ),
              )
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
      context.go('/review/${drillSession!.deckId}/session');
    }

    final enrolledCount = drillSession?.correctCount ?? 0;

    final breakdown = <StudyRating, int>{
      for (final type in StudyRating.values) type: 0,
    };
    for (final a in answers) {
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
            total:
                drillSession?.totalQuestions ?? reviewSession?.totalCards ?? 0,
          ),

          // The list of individual answers
          if (answers.isNotEmpty)
            ListingStatesWrapper.list(
              items: answers,
              useParentScroll: true,
              separatorHeight: tokens.spaceLayoutGapSm,
              itemBuilder: (context, _, answer) {
                return AnswerResultTile(
                  userAnswer: answer.userAnswer,
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
  const _AnswerResult({required this.userAnswer, required this.type});

  factory _AnswerResult.fromStepRecord(StudySessionStepRecord record) {
    return _AnswerResult(userAnswer: record.userAnswer, type: record.rating);
  }

  final String userAnswer;
  final StudyRating type;
}
