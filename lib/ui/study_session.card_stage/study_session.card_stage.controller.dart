import 'package:boo_mondai/lib.barrel.dart'
    show StudyRating, StudySessionAnswer;
import 'package:signals_hooks/signals_hooks.dart';

class StudySessionCardStageController {
  StudySessionCardStageController({
    required bool canReveal,
    StudySessionAnswer? answer,
  }) : answer = signal(answer),
       canReveal = signal(canReveal);

  final Signal<StudySessionAnswer?> answer;

  ///  is the rating that has already been decided, but has not been submitted yet.
  final Signal<StudyRating?> pendingRating = signal(null);
  final Signal<bool> canReveal;

  final Signal<bool> isRevealed = signal(false);

  void reveal({StudyRating? pendingRating}) {
    if (!canReveal.value || isRevealed.value) return;

    isRevealed.value = true;
    this.pendingRating.value = pendingRating;
  }

  void revealWithAnswer(StudySessionAnswer value) {
    answer.value = value;
    canReveal.value = true;
    isRevealed.value = true;
  }

  void dispose() {
    canReveal.dispose();
    pendingRating.dispose();
    isRevealed.dispose();
    answer.dispose();
  }
}
