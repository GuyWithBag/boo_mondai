import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardVerticalAlignmentControl,
        EditDeckFormValidator,
        FormField,
        TextFieldCard,
        WordScrambleEditorController,
        WordScrambleTemplate;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class WordScrambleEditor extends SignalHookWidget {
  const WordScrambleEditor({
    required this.template,
    required this.onChanged,
    super.key,
  });

  final WordScrambleTemplate template;
  final ValueChanged<WordScrambleTemplate> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useMemoized(
      () => WordScrambleEditorController(
        template: template,
        onChanged: onChanged,
      ),
      [template.id],
    );
    useEffect(() => editor.dispose, [editor]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: tokens.spaceLayoutGapMd,
      children: [
        CardVerticalAlignmentControl(
          value: editor.verticallyCentered,
          onChanged: editor.updateVerticallyCentered,
        ),
        FormField<String>(
          value: editor.sentenceController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Sentence to Scramble',
            placeholder: 'Write the sentence learners will reconstruct.',
            controller: editor.sentenceController,
            onChanged: (value) {
              field.didChange(value);
              editor.updateSentence(value);
            },
          ),
        ),
      ],
    );
  }
}
