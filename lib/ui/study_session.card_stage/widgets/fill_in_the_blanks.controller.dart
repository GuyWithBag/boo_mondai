import 'dart:convert';

import 'package:boo_mondai/features/cards/helpers/fill_in_the_blanks_prompt.helper.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        FillInTheBlanksTemplate,
        CardTemplateController,
        StudySessionAnswer,
        StudySessionCardStageController;
import 'package:signals/signals.dart';

class FillInTheBlanksController implements CardTemplateController {
  FillInTheBlanksController({
    required this.template,
    this.cardStageController,
  }) {
    final blankCount = segments.value
        .where((segment) => segment.key != null)
        .length;
    answers.value = List.filled(blankCount, '');
    answerEffect = effect(() {
      final nextAnswer = encodedAnswer.value;
      cardStageController?.answer.value = nextAnswer == null
          ? null
          : StudySessionAnswer(value: nextAnswer);
      cardStageController?.canReveal.value = isComplete.value;
    });
  }

  final FillInTheBlanksTemplate template;
  final StudySessionCardStageController? cardStageController;

  final answers = signal<List<String>>(<String>[]);

  late final Computed<List<FillInTheBlanksPromptSegment>> segments = computed(
    () => scanFillInTheBlanksPrompt(template.promptText, template.answerKeys),
  );

  late final Computed<bool> isComplete = computed(
    () =>
        answers.value.isNotEmpty &&
        answers.value.length ==
            segments.value.where((s) => s.key != null).length &&
        answers.value.every((value) => value.trim().isNotEmpty),
  );

  late final Computed<String?> encodedAnswer = computed(
    () => isComplete.value ? _encode(answers.value) : null,
  );

  late final EffectCleanup answerEffect;

  void updateAnswer(int index, String value) {
    if (index < 0 || index >= answers.value.length) return;
    final next = [...answers.value]..[index] = value;
    answers.value = next;
  }

  int blankIndexForSegment(int segmentIndex) => segments.value
      .take(segmentIndex)
      .where((segment) => segment.key != null)
      .length;

  bool isCorrect(int index) {
    final key = segments.value
        .where((segment) => segment.key != null)
        .elementAt(index)
        .key!;
    return index < answers.value.length && key.accepts(answers.value[index]);
  }

  @override
  void dispose() {
    answerEffect();
    encodedAnswer.dispose();
    isComplete.dispose();
    segments.dispose();
    answers.dispose();
  }
}

String _encode(List<String> answers) => jsonEncode(answers);
