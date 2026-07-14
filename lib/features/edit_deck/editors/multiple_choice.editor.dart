import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateFormState,
        EditDeckFormValidator,
        FormField,
        TextFieldCard,
        MultipleChoiceOptionsPanel,
        useMultipleChoiceEditor,
        AppTokens,
        CardVerticalAlignmentControl;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceEditor extends HookWidget {
  const MultipleChoiceEditor({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final editor = useMultipleChoiceEditor(formState);
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        CardVerticalAlignmentControl(formState: formState),
        FormField<String>(
          value: editor.promptController.text,
          listenable: editor.promptController,
          valueReader: () => editor.promptController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Front (Prompt)',
            placeholder: 'Type a question...',
            controller: editor.promptController,
            onChanged: field.didChange,
          ),
        ),
        FormField(
          value: editor.options,
          listenable: formState.multipleChoiceOptions,
          valueReader: () => formState.multipleChoiceOptions.value,
          validator: EditDeckFormValidator.multipleChoiceOptions,
          builder: (_, _) => MultipleChoiceOptionsPanel(controller: editor),
        ),
      ],
    );
  }
}
