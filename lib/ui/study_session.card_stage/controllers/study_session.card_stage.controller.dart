import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, StudyRating, StudySessionAnswer;
import 'package:boo_mondai/ui/study_session.card_stage/widgets/card_template.controller.dart';
import 'package:signals_hooks/signals_hooks.dart';

typedef CardTemplateControllerFactory =
    CardTemplateController Function(StudySessionCardStageController stage);

class StudySessionCardStageController {
  StudySessionCardStageController({
    CardTemplate? template,
    required bool canReveal,
    StudySessionAnswer? answer,
    CardTemplateControllerFactory? createCardController,
  }) : template = signal(template),
       answer = signal(answer),
       canReveal = signal(canReveal) {
    cardController = createCardController?.call(this);
  }

  final Signal<CardTemplate?> template;
  final Signal<StudySessionAnswer?> answer;
  CardTemplateController? cardController;

  ///  is the rating that has already been decided, but has not been submitted yet.
  final Signal<StudyRating?> pendingRating = signal(null);
  final Signal<bool> canReveal;

  final Signal<bool> isRevealed = signal(false);

  void reset({
    CardTemplate? template,
    required bool canReveal,
    StudySessionAnswer? answer,
    CardTemplateControllerFactory? createCardController,
  }) {
    cardController?.dispose();
    cardController = null;
    this.template.value = template;
    this.answer.value = answer;
    this.canReveal.value = canReveal;
    pendingRating.value = null;
    isRevealed.value = false;
    cardController = createCardController?.call(this);
  }

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
    template.dispose();
    canReveal.dispose();
    pendingRating.dispose();
    isRevealed.dispose();
    answer.dispose();
  }
}
