import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplateFormState,
        CardVerticalAlignmentControl,
        EditDeckFormValidator,
        FormField,
        TextFieldCard;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class WordScrambleEditor extends HookWidget {
  const WordScrambleEditor({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: tokens.spaceLayoutGapMd,
      children: [
        CardVerticalAlignmentControl(formState: formState),
        FormField<String>(
          value: formState.frontController.text,
          listenable: formState.frontController,
          valueReader: () => formState.frontController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Sentence to Scramble',
            placeholder: 'Write the sentence learners will reconstruct.',
            controller: formState.frontController,
            onChanged: field.didChange,
          ),
        ),
      ],
    );
  }
}
