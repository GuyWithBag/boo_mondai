import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceOption,
        MultipleChoiceOptionHelper,
        MultipleChoiceTemplate;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class MultipleChoiceEditorController {
  MultipleChoiceEditorController({
    required this.template,
    required this.onChanged,
  }) {
    promptController.text = template.questionPrompt;
    options.value = template.options;
    verticallyCentered.value = template.verticallyCentered;
  }

  final MultipleChoiceTemplate template;
  final ValueChanged<MultipleChoiceTemplate> onChanged;

  final promptController = TextEditingController();
  final options = signal<List<MultipleChoiceOption>>(const []);
  final verticallyCentered = signal(true);

  void updatePrompt(String value) => emit(questionPrompt: value);

  void updateVerticallyCentered(bool value) {
    verticallyCentered.value = value;
    emit(verticallyCentered: value);
  }

  void addOption() {
    options.value = MultipleChoiceOptionHelper.add(
      options.value,
      templateId: template.id,
    );
    emit();
  }

  void removeOption(int index) {
    options.value = MultipleChoiceOptionHelper.removeAt(options.value, index);
    emit();
  }

  void updateOptionText(int index, String text) {
    options.value = MultipleChoiceOptionHelper.updateTextAt(
      options.value,
      index,
      text,
    );
    emit();
  }

  void selectCorrectOption(int index) {
    options.value = MultipleChoiceOptionHelper.selectCorrectAt(
      options.value,
      index,
    );
    emit();
  }

  void emit({String? questionPrompt, bool? verticallyCentered}) {
    onChanged(
      MultipleChoiceTemplate(
        id: template.id,
        deckId: template.deckId,
        sortOrder: template.sortOrder,
        createdAt: template.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: template.deletedAt,
        purgeAfter: template.purgeAfter,
        sourceTemplateId: template.sourceTemplateId,
        tags: template.tags,
        verticallyCentered: verticallyCentered ?? this.verticallyCentered.value,
        questionPrompt: questionPrompt ?? promptController.text,
        options: options.value,
        multipleAnswers: template.multipleAnswers,
        randomizeOptionsOrdering: template.randomizeOptionsOrdering,
      ),
    );
  }

  void dispose() {
    promptController.dispose();
    options.dispose();
    verticallyCentered.dispose();
  }
}
