import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardVerticalAlignmentControl,
        EditDeckController,
        EditDeckFormValidator,
        FormField,
        TextFieldCard,
        WordScrambleEditorController;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

// ToDo: Add functionality to add extra words, and more functionality to be able to add submit or not even when not all words are used.
class WordScrambleEditor extends SignalHookWidget {
  const WordScrambleEditor({required this.editDeckController, super.key});

  final EditDeckController editDeckController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useMemoized(
      () =>
          WordScrambleEditorController(editDeckController: editDeckController),
      [editDeckController.selectedTemplateKey.value],
    );
    useEffect(() => editor.dispose, [editor]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: tokens.spaceLayoutGapMd,
      children: [
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
        CardVerticalAlignmentControl(
          value: editor.template.verticallyCentered,
          onChanged: editor.onVerticalAlignmentControlChanged,
        ),
      ],
    );
  }
}
