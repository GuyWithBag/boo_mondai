import 'package:boo_mondai/lib.barrel.dart'
    show DeckCardFormState, TextFieldCard, useFlashcardEditor;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'direction_selector.dart';
import 'responsive_two_column.dart';

class FlashcardEditor extends HookWidget {
  const FlashcardEditor({required this.formState, super.key});

  final DeckCardFormState formState;

  @override
  Widget build(BuildContext context) {
    final editor = useFlashcardEditor(formState);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [
        CardTypeSelector(
          selected: editor.cardType,
          hint: editor.directionHint,
          onChanged: editor.setCardType,
        ),
        ResponsiveTwoColumn(
          children: [
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
        ),
      ],
    );
  }
}
