import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardFrontSide extends StatelessWidget {
  const FlashcardFrontSide({
    required this.template,
    required this.reviewCard,
    required this.onReveal,
    super.key,
  });

  final FlashcardTemplate template;
  final ReviewCard reviewCard;
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
                template.getQuestion(isReversed: reviewCard.isReversed),
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
              child: TactileButton(
                tone: TactileTone.text,
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
