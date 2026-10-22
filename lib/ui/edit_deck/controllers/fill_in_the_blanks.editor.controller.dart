import 'package:boo_mondai/features/cards/helpers/fill_in_the_blanks_prompt.helper.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        CasingType,
        FillInTheBlankAnswerKey,
        FillInTheBlanksTemplate,
        CardTemplateEditorController;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class FillInTheBlanksEditorController
    extends CardTemplateEditorController<FillInTheBlanksTemplate> {
  FillInTheBlanksEditorController({required super.editDeckController}) {
    promptController.text = template.promptText;
  }

  final promptController = TextEditingController();
  late final Computed<String> promptText = computed(() => template.promptText);
  late final Computed<List<FillInTheBlankAnswerKey>> answerKeys = computed(
    () => template.answerKeys,
  );
  late final Computed<List<FillInTheBlanksPromptSegment>> segments = computed(
    () => scanFillInTheBlanksPrompt(promptText.value, answerKeys.value),
  );

  void updatePrompt(String value) {
    template = template.copyWith(promptText: value);
  }

  List<FillInTheBlankAnswerKey> buildKeys() => answerKeys.value;

  bool get canCreateBlank {
    final selection = promptController.selection;
    if (!selection.isValid || selection.isCollapsed) return false;
    return promptController.text
        .substring(selection.start, selection.end)
        .trim()
        .isNotEmpty;
  }

  void createBlankFromSelection() {
    if (!canCreateBlank) return;

    final selection = promptController.selection;
    final selectedText = promptController.text
        .substring(selection.start, selection.end)
        .trim();
    final current = template;
    if (current.answerKeys.any((key) => key.value == selectedText)) return;
    template = current.copyWith(
      answerKeys: [
        ...current.answerKeys,
        FillInTheBlankAnswerKey(
          value: selectedText,
          casingType: CasingType.any,
          order: current.answerKeys.length,
        ),
      ],
    );
  }

  void removeAnswerKey(int index) {
    final current = template;
    if (index < 0 || index >= current.answerKeys.length) return;
    template = current.copyWith(
      answerKeys: [
        for (final entry in current.answerKeys.asMap().entries)
          if (entry.key != index)
            entry.value.copyWith(
              order: entry.key < index ? entry.key : entry.key - 1,
            ),
      ],
    );
  }

  void moveAnswerKeyUp(int index) {
    moveAnswerKey(index, index - 1);
  }

  void moveAnswerKeyDown(int index) {
    moveAnswerKey(index, index + 1);
  }

  void moveAnswerKey(int from, int to) {
    final current = template;
    if (from < 0 ||
        from >= current.answerKeys.length ||
        to < 0 ||
        to >= current.answerKeys.length) {
      return;
    }
    final keys = [...current.answerKeys];
    final key = keys.removeAt(from);
    keys.insert(to, key);
    template = current.copyWith(
      answerKeys: [
        for (final entry in keys.asMap().entries)
          entry.value.copyWith(order: entry.key),
      ],
    );
  }

  void updateAnswerKeyCasingType(int index, CasingType casingType) {
    final current = template;
    if (index < 0 || index >= current.answerKeys.length) return;
    template = current.copyWith(
      answerKeys: [
        for (final entry in current.answerKeys.asMap().entries)
          entry.key == index
              ? entry.value.copyWith(casingType: casingType)
              : entry.value,
      ],
    );
  }

  @override
  void dispose() {
    promptController.dispose();
    promptText.dispose();
    answerKeys.dispose();
    segments.dispose();
    super.dispose();
  }
}
