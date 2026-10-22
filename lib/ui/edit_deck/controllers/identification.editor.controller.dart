import 'package:boo_mondai/lib.barrel.dart'
    show
        CasingType,
        IdentificationAnswerKey,
        IdentificationTemplate,
        CardTemplateEditorController;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class IdentificationEditorController
    extends CardTemplateEditorController<IdentificationTemplate> {
  IdentificationEditorController({required super.editDeckController}) {
    promptController.text = template.promptText;
  }

  final promptController = TextEditingController();
  late final Computed<List<IdentificationAnswerKey>> answers = computed(
    () => template.answers,
  );

  void updatePrompt(String value) {
    template = template.copyWith(promptText: value);
  }

  void addAnswer() {
    final current = template;
    template = current.copyWith(
      answers: [
        ...current.answers,
        IdentificationAnswerKey.createDummy(
          templateId: current.id,
          displayOrder: current.answers.length,
        ),
      ],
    );
  }

  void removeAnswer(int index) {
    final current = template;
    if (current.answers.length <= 1 ||
        index < 0 ||
        index >= current.answers.length) {
      return;
    }
    template = current.copyWith(
      answers: [
        for (final entry in current.answers.asMap().entries)
          if (entry.key != index)
            entry.value.copyWith(
              displayOrder: entry.key < index ? entry.key : entry.key - 1,
            ),
      ],
    );
  }

  void updateAnswer(int index, String answer) {
    final current = template;
    if (index < 0 || index >= current.answers.length) return;
    template = current.copyWith(
      answers: [
        for (final entry in current.answers.asMap().entries)
          entry.key == index
              ? entry.value.copyWith(value: answer)
              : entry.value,
      ],
    );
  }

  void updateCasingType(int index, CasingType casingType) {
    final current = template;
    if (index < 0 || index >= current.answers.length) return;
    template = current.copyWith(
      answers: [
        for (final entry in current.answers.asMap().entries)
          entry.key == index
              ? entry.value.copyWith(casingType: casingType)
              : entry.value,
      ],
    );
  }

  void moveAnswerUp(int index) {
    moveAnswer(index, index - 1);
  }

  void moveAnswerDown(int index) {
    moveAnswer(index, index + 1);
  }

  void moveAnswer(int from, int to) {
    final current = template;
    if (from < 0 ||
        from >= current.answers.length ||
        to < 0 ||
        to >= current.answers.length) {
      return;
    }
    final answers = [...current.answers];
    final answer = answers.removeAt(from);
    answers.insert(to, answer);
    template = current.copyWith(
      answers: [
        for (final entry in answers.asMap().entries)
          entry.value.copyWith(displayOrder: entry.key),
      ],
    );
  }

  @override
  void dispose() {
    promptController.dispose();
    answers.dispose();
    super.dispose();
  }
}
