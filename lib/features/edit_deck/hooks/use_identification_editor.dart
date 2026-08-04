import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateFormState,
        CasingType,
        IdentificationAnswerData,
        IdentificationAnswerHelper;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class IdentificationEditorController {
  const IdentificationEditorController({
    required this.promptController,
    required this.formState,
    required this.answers,
  });

  final TextEditingController promptController;
  final CardTemplateFormState formState;
  final List<IdentificationAnswerData> answers;

  void addAnswer() {
    formState.identificationAnswers.value = IdentificationAnswerHelper.add(
      answers,
    );
  }

  void removeAnswer(int index) {
    formState.identificationAnswers.value = IdentificationAnswerHelper.removeAt(
      answers,
      index,
    );
  }

  void updateAnswer(int index, String answer) {
    formState.identificationAnswers.value =
        IdentificationAnswerHelper.updateAnswerAt(answers, index, answer);
  }

  void updateCasingType(int index, CasingType casingType) {
    formState.identificationAnswers.value =
        IdentificationAnswerHelper.updateCasingTypeAt(
          answers,
          index,
          casingType,
        );
  }

  void moveAnswerUp(int index) {
    formState.identificationAnswers.value = IdentificationAnswerHelper.move(
      answers,
      index,
      index - 1,
    );
  }

  void moveAnswerDown(int index) {
    formState.identificationAnswers.value = IdentificationAnswerHelper.move(
      answers,
      index,
      index + 1,
    );
  }
}

IdentificationEditorController useIdentificationEditor(
  CardTemplateFormState formState,
) {
  final answers = useValueListenable(formState.identificationAnswers);

  return IdentificationEditorController(
    promptController: formState.frontController,
    formState: formState,
    answers: answers,
  );
}
