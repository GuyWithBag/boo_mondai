import 'package:boo_mondai/lib.barrel.dart'
    show
        FlashcardTemplate,
        StudyCard,
        AppTokens,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        ButtonTone,
        Button,
        PhysicalCardSide;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardFrontSide extends StatelessWidget {
  const FlashcardFrontSide({
    required this.template,
    required this.studyCard,
    required this.onReveal,
    super.key,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return PhysicalCardSide(
      maxWidth: 460,
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Text(
                template.getQuestion(isReversed: studyCard.isReversed),
                textAlign: TextAlign.center,
                style: appTextStyle.resolve(tokens, [
                  TextSize.cardFront,
                  TextWeight.heavy,
                  TextTone.primary,
                ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Button(
                tone: ButtonTone.text,
                leading: Icon(Icons.touch_app),
                onPressed: onReveal,
                child: const Text('Tap to reveal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
