import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceOption,
        MultipleChoiceTemplate,
        CardTemplateEditorController;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class MultipleChoiceEditorController
    extends CardTemplateEditorController<MultipleChoiceTemplate> {
  MultipleChoiceEditorController({required super.editDeckController}) {
    promptController.text = template.questionPrompt;
  }

  final promptController = TextEditingController();
  late final Computed<List<MultipleChoiceOption>> options = computed(
    () => template.options,
  );

  void updatePrompt(String value) {
    template = template.copyWith(questionPrompt: value);
  }

  void addOption() {
    final current = template;
    template = current.copyWith(
      options: [
        ...current.options,
        MultipleChoiceOption.createDummy(
          templateId: current.id,
          displayOrder: current.options.length,
        ),
      ],
    );
  }

  void removeOption(int index) {
    final current = template;
    if (index < 0 || index >= current.options.length) return;
    template = current.copyWith(
      options: [
        for (final entry in current.options.asMap().entries)
          if (entry.key != index)
            entry.value.copyWith(
              displayOrder: entry.key < index ? entry.key : entry.key - 1,
            ),
      ],
    );
  }

  void updateOptionText(int index, String text) {
    final current = template;
    if (index < 0 || index >= current.options.length) return;
    template = current.copyWith(
      options: [
        for (final entry in current.options.asMap().entries)
          entry.key == index
              ? entry.value.copyWith(optionText: text)
              : entry.value,
      ],
    );
  }

  void selectCorrectOption(int index) {
    final current = template;
    if (index < 0 || index >= current.options.length) return;
    template = current.copyWith(
      options: [
        for (final entry in current.options.asMap().entries)
          entry.value.copyWith(isCorrect: entry.key == index),
      ],
    );
  }

  @override
  void dispose() {
    promptController.dispose();
    options.dispose();
    super.dispose();
  }
}
