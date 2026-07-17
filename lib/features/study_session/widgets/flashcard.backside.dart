import 'package:boo_mondai/lib.barrel.dart'
    show
        FlashcardTemplate,
        StudyCard,
        AppTokens,
        AlignedScrollView,
        MarkdownText,
        MarkdownTextMode,
        ScaleHelper,
        textStyle,
        TextColor,
        TextSize,
        TextWeight;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardBackSide extends StatelessWidget {
  const FlashcardBackSide({
    required this.template,
    required this.studyCard,
    this.maxWidth = 460,
    this.contentScale = 1,
    super.key,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
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
    final gap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapMd,
      contentScale,
    );
    final dividerHeight = ScaleHelper.getScaledValue(16, contentScale);
    final dividerThickness = ScaleHelper.getScaledValue(1, contentScale);

    return AlignedScrollView(
      verticallyCentered: template.verticallyCentered,
      padding: padding,
      child: Column(
        key: const ValueKey('flashcard-back'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: gap,
        children: [
          MarkdownText(
            mode: MarkdownTextMode.previewSelectable,
            data: template.getQuestion(isReversed: studyCard.isReversed),
            baseTextStyle: markdownTextStyle,
            contentScale: contentScale,
            resolveAttachmentUrl: template.resolveAttachmentUrl,
            defaultMarkdownAlignment: WrapAlignment.center,
          ),
          Divider(height: dividerHeight, thickness: dividerThickness),
          MarkdownText(
            mode: MarkdownTextMode.previewSelectable,
            data: template.getAnswer(isReversed: studyCard.isReversed),
            baseTextStyle: markdownTextStyle,
            contentScale: contentScale,
            defaultMarkdownAlignment: WrapAlignment.center,
            resolveAttachmentUrl: template.resolveAttachmentUrl,
          ),
        ],
      ),
    );
  }
}
