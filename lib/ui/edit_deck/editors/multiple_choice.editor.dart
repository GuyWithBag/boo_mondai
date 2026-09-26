import 'package:boo_mondai/lib.barrel.dart'
    show
        CardVerticalAlignmentControl,
        EditDeckFormValidator,
        FormField,
        MultipleChoiceEditorController,
        MultipleChoiceOptionsPanel,
        MultipleChoiceTemplate,
        TextFieldCard,
        AppTokens;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceEditor extends SignalHookWidget {
  const MultipleChoiceEditor({
    required this.template,
    required this.onChanged,
    super.key,
  });

  final MultipleChoiceTemplate template;
  final ValueChanged<MultipleChoiceTemplate> onChanged;

  @override
  Widget build(BuildContext context) {
    final editor = useMemoized(
      () => MultipleChoiceEditorController(
        template: template,
        onChanged: onChanged,
      ),
      [template.id],
    );
    useEffect(() => editor.dispose, [editor]);
    final options = editor.options.value;
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        CardVerticalAlignmentControl(
          value: editor.verticallyCentered,
          onChanged: editor.updateVerticallyCentered,
        ),
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
      ],
    );
  }
}
