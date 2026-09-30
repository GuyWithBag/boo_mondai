import 'package:boo_mondai/lib.barrel.dart'
    show StudyRating, StudySessionAnswer, WordScrambleTemplate;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/word_scramble.controller.dart';
import 'package:signals_hooks/signals_hooks.dart';

class StudySessionCardStageController {
  StudySessionCardStageController({
    required bool canReveal,
    StudySessionAnswer? answer,
    WordScrambleTemplate? wordScrambleTemplate,
  }) : answer = signal(answer),
       canReveal = signal(canReveal) {
    wordScrambleController = wordScrambleTemplate == null
        ? null
        : WordScrambleController(
            template: wordScrambleTemplate,
            answer: this.answer,
            canReveal: this.canReveal,
            isRevealed: isRevealed,
          );
  }

  final Signal<StudySessionAnswer?> answer;
  late final WordScrambleController? wordScrambleController;

  ///  is the rating that has already been decided, but has not been submitted yet.
  final Signal<StudyRating?> pendingRating = signal(null);
  final Signal<bool> canReveal;

  final Signal<bool> isRevealed = signal(false);
  final isBottomNavBarHidden = signal(false);

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
    wordScrambleController?.dispose();
    canReveal.dispose();
    pendingRating.dispose();
    isRevealed.dispose();
    answer.dispose();
  }
}
