import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        ButtonTone,
        FlashcardTemplate,
        MarkdownText,
        PhysicalCardSide,
        StudyCard;
import 'package:flutter/material.dart';

class FlashcardFrontSide extends StatelessWidget {
  const FlashcardFrontSide({
    required this.template,
    required this.studyCard,
    required this.onReveal,
    this.showRevealButton = true,
    this.maxWidth = 460,
    super.key,
  });

  const FlashcardFrontSide.preview({
    required this.template,
    required this.studyCard,
    this.maxWidth = 460,
    super.key,
  }) : onReveal = null,
       showRevealButton = false;

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final VoidCallback? onReveal;
  final bool showRevealButton;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return PhysicalCardSide(
      maxWidth: maxWidth,
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: MarkdownText(
                data: template.getQuestion(isReversed: studyCard.isReversed),
              ),
            ),
            if (showRevealButton)
              Align(
                alignment: Alignment.bottomCenter,
                child: Button(
                  variants: const [ButtonTone.text],
                  leading: const Icon(Icons.touch_app),
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
