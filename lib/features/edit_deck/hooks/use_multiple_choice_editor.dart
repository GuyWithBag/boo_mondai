import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateFormState,
        MultipleChoiceOption,
        MultipleChoiceOptionHelper;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MultipleChoiceEditorController {
  const MultipleChoiceEditorController({
    required this.formState,
    required this.options,
  });

  final CardTemplateFormState formState;
  final List<MultipleChoiceOption> options;

  TextEditingController get promptController => formState.frontController;

  void addOption() {
    formState.multipleChoiceOptions.value = MultipleChoiceOptionHelper.add(
      options,
      templateId: options.firstOrNull?.templateId ?? '',
    );
  }

  void removeOption(int index) {
    formState.multipleChoiceOptions.value = MultipleChoiceOptionHelper.removeAt(
      options,
      index,
    );
  }

  void updateOption(int index, MultipleChoiceOption option) {
    formState.multipleChoiceOptions.value = MultipleChoiceOptionHelper.updateAt(
      options,
      index,
      option,
    );
  }

  void updateOptionText(int index, String text) {
    formState.multipleChoiceOptions.value =
        MultipleChoiceOptionHelper.updateTextAt(options, index, text);
  }

  void selectCorrectOption(int index) {
    formState.multipleChoiceOptions.value =
        MultipleChoiceOptionHelper.selectCorrectAt(options, index);
  }
}

MultipleChoiceEditorController useMultipleChoiceEditor(
  CardTemplateFormState formState,
) {
  final options = useValueListenable(formState.multipleChoiceOptions);

  return MultipleChoiceEditorController(formState: formState, options: options);
}
