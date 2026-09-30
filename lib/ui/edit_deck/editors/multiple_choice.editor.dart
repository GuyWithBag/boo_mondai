import 'package:boo_mondai/lib.barrel.dart'
    show
        CardVerticalAlignmentControl,
        EditDeckController,
        EditDeckFormValidator,
        FormField,
        MultipleChoiceEditorController,
        MultipleChoiceOptionsPanel,
        TextFieldCard,
        AppTokens;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceEditor extends SignalHookWidget {
  const MultipleChoiceEditor({required this.editDeckController, super.key});

  final EditDeckController editDeckController;

  @override
  Widget build(BuildContext context) {
    final editor = useMemoized(
      () => MultipleChoiceEditorController(
        editDeckController: editDeckController,
      ),
      [editDeckController.selectedTemplateKey.value],
    );
    useEffect(() => editor.dispose, [editor]);
    final options = editor.options.value;
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        FormField<String>(
          value: editor.promptController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Front (Prompt)',
            placeholder: 'Type a question...',
            controller: editor.promptController,
            onChanged: (value) {
              field.didChange(value);
              editor.updatePrompt(value);
            },
          ),
        ),
        FormField(
          value: options,
          validator: EditDeckFormValidator.multipleChoiceOptions,
          builder: (_, _) => MultipleChoiceOptionsPanel(controller: editor),
        ),
        CardVerticalAlignmentControl(
          value: editor.template.verticallyCentered,
          onChanged: editor.onVerticalAlignmentControlChanged,
        ),
      ],
    );
  }
}
