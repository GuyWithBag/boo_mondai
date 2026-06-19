import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateFormState,
        TextFieldCard,
        useFlashcardEditor,
        CardTypeSelector,
        AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class FlashcardEditor extends HookWidget {
  const FlashcardEditor({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final editor = useFlashcardEditor(formState);
    final tokens = context.themeTokens<AppTokens>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: tokens.spaceLayoutGapMd,
      children: [
        CardTypeSelector(
          selected: editor.cardType,
          hint: editor.directionHint,
          onChanged: editor.setCardType,
        ),
        TextFieldCard(
          title: 'Front (Prompt)',
          placeholder: 'Type a word...',
          controller: editor.frontController,
        ),
        TextFieldCard(
          title: 'Back (Answer)',
          placeholder: 'Type the translation...',
          controller: editor.backController,
        ),
      ],
    );
  }
}
