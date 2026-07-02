import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonVariant,
        FlashcardTemplate,
        MarkdownText,
        MarkdownTextMode,
        StudyCard,
        buttonStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardFrontSide extends StatelessWidget {
  const FlashcardFrontSide({
    required this.template,
    required this.studyCard,
    this.onReveal,
    this.showRevealButton = true,
    this.maxWidth = 460,
    super.key,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final VoidCallback? onReveal;
  final bool showRevealButton;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: MarkdownText(
              mode: MarkdownTextMode.previewSelectable,
              data: template.getQuestion(isReversed: studyCard.isReversed),
              resolveAttachmentUrl: template.resolveAttachmentUrl,
            ),
          ),
          if (showRevealButton)
            Align(
              alignment: Alignment.bottomCenter,
              child: Button(
                style: buttonStyle.resolve(tokens, const [
                  ButtonVariant.text,
                  ButtonColor.baseline,
                ]),
                leading: const Icon(Icons.touch_app),
                onPressed: onReveal,
                child: const Text('Tap to reveal'),
              ),
            ),
        ],
      ),
    );
  }
}
