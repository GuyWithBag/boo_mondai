import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, StudyRating, StudySessionAnswer;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/card_template.controller.dart';
import 'package:signals_hooks/signals_hooks.dart';

class StudySessionCardStageController<T extends CardTemplateController> {
  StudySessionCardStageController({
    required this.template,
    required bool canReveal,
    StudySessionAnswer? answer,
    T Function(StudySessionCardStageController<T> stage)? createCardController,
  }) : answer = signal(answer),
       canReveal = signal(canReveal) {
    cardController = createCardController?.call(this);
  }

  final CardTemplate? template;
  final Signal<StudySessionAnswer?> answer;
  late final T? cardController;

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
    cardController?.dispose();
    canReveal.dispose();
    pendingRating.dispose();
    isRevealed.dispose();
    answer.dispose();
  }
}
