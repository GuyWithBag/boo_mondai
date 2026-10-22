import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonVariant,
        FlashcardTemplate,
        AlignedScrollView,
        MarkdownText,
        MarkdownTextMode,
        ScaleHelper,
        textStyle,
        TextColor,
        TextSize,
        TextWeight,
        StudyCard,
        MarkdownHelper;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardFrontSide extends StatelessWidget {
  const FlashcardFrontSide({
    required this.template,
    required this.studyCard,
    this.onReveal,
    this.showRevealButton = true,
    this.maxWidth = 460,
    this.contentScale = 1,
    super.key,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final VoidCallback? onReveal;
  final bool showRevealButton;
  final double maxWidth;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final markdownTextStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.label,
        TextWeight.body,
        TextColor.baseline,
      ]),
      contentScale,
    );
    final padding = ScaleHelper.getScaledEdgeInsets(
      EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      contentScale,
    );

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: AlignedScrollView(
              verticallyCentered: template.verticallyCentered,
              padding: padding,
              child: MarkdownText(
                mode: MarkdownTextMode.previewSelectable,
                data: template.getQuestion(isReversed: studyCard.isReversed),
                baseTextStyle: markdownTextStyle,
                contentScale: contentScale,
                fitContent: false,
                defaultMarkdownAlignment: WrapAlignment.center,
                resolveAttachmentUrl:
                    MarkdownHelper.resolveTemplateAttachmentUrl(template),
              ),
            ),
          ),
          if (showRevealButton)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: ScaleHelper.getScaledEdgeInsets(
                  EdgeInsets.all(tokens.spaceLayoutPaddingSm),
                  contentScale,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: ScaleHelper.getScaledValue(
                    tokens.spaceLayoutGapXsm,
                    contentScale,
                  ),
                  children: [
                    Text(
                      'Guess the answer in your mind, then reveal and rate yourself.',
                      textAlign: TextAlign.center,
                      style: ScaleHelper.getTextStyleWithScaledFontSize(
                        textStyle.resolve(tokens, const [
                          TextSize.labelSmall,
                          TextWeight.body,
                          TextColor.muted,
                        ]),
                        contentScale,
                      ),
                    ),
                    Button(
                      variants: const [ButtonVariant.text],
                      elevated: false,
                      leading: const Icon(Icons.touch_app),
                      contentScale: contentScale,
                      onPressed: onReveal,
                      child: const Text('Tap to reveal'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
