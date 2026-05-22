import 'package:boo_mondai/models/models.barrel.dart';
import 'package:flutter/material.dart';

import 'direction_selector.dart';
import '../../widgets/text_field_card.dart';
import 'responsive_two_column.dart';

class FlashcardEditor extends StatelessWidget {
  const FlashcardEditor({
    required this.cardType,
    required this.onCardTypeChanged,
    required this.frontController,
    required this.backController,
    super.key,
  });

  final CardType cardType;
  final ValueChanged<CardType> onCardTypeChanged;
  final TextEditingController frontController;
  final TextEditingController backController;

  @override
  Widget build(BuildContext context) {
    final directionHint = switch (cardType) {
      CardType.both => 'Generates 2 Notes: Front to Back and Back to Front.',
      CardType.reversed => 'Generates 1 Note: Back to Front.',
      CardType.normal => 'Generates 1 Note: Front to Back.',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [
        CardTypeSelector(
          selected: cardType,
          hint: directionHint,
          onChanged: onCardTypeChanged,
        ),
        ResponsiveTwoColumn(
          children: [
            TextFieldCard(
              title: 'Front (Prompt)',
              placeholder: 'Type a word...',
              controller: frontController,
            ),
            TextFieldCard(
              title: 'Back (Answer)',
              placeholder: 'Type the translation...',
              controller: backController,
            ),
          ],
        ),
      ],
    );
  }
}
