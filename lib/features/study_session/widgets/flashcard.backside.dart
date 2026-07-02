import 'package:boo_mondai/lib.barrel.dart'
    show
        FlashcardTemplate,
        StudyCard,
        AppTokens,
        MarkdownText,
        MarkdownTextMode;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardBackSide extends StatelessWidget {
  const FlashcardBackSide({
    required this.template,
    required this.studyCard,
    this.maxWidth = 460,
    super.key,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Center(
      child: Column(
        key: const ValueKey('flashcard-back'),
        mainAxisSize: MainAxisSize.min,
        spacing: tokens.spaceLayoutGapMd,
        children: [
          MarkdownText(
            mode: MarkdownTextMode.previewSelectable,
            data: template.getQuestion(isReversed: studyCard.isReversed),
            resolveAttachmentUrl: template.resolveAttachmentUrl,
          ),
          Divider(),
          MarkdownText(
            mode: MarkdownTextMode.previewSelectable,
            data: template.getAnswer(isReversed: studyCard.isReversed),
            resolveAttachmentUrl: template.resolveAttachmentUrl,
          ),
        ],
      ),
    );
  }
}
