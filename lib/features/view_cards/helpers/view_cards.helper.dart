import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplate,
        FillInTheBlanksCard,
        FillInTheBlanksTemplate,
        FlashcardCard,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchMadnessTemplate,
        MarkdownText,
        MarkdownTextMode,
        MatchingTypeCard,
        MultipleChoiceCard,
        MultipleChoiceTemplate,
        PhysicalCardController,
        ScaleHelper,
        StudyCard,
        textStyle,
        TextColor,
        TextSize,
        TextWeight,
        ViewCardsTileSide,
        WordScrambleTemplate,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

abstract class ViewCardsHelper {
  static Widget getCorrespondingViewCard(
    AppTokens tokens, {
    required CardTemplate? template,
    required StudyCard? studyCard,
    required double width,
    required ViewCardsTileSide side,
    required PhysicalCardController? controller,
    double contentScale = 1,
  }) {
    if (template == null) {
      return Surface(
        style: surfaceStyle.resolve(tokens),
        child: const Text('Template Null'),
      );
    }
    final promptTextStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.label,
        TextWeight.body,
        TextColor.baseline,
      ]),
      contentScale,
    );

    return switch (template) {
      FlashcardTemplate t => FlashcardCard(
        controller: controller,
        template: t,
        studyCard:
            studyCard ??
            getPreviewStudyCard(
              template,
              isReversed: side == ViewCardsTileSide.back,
            ),
        maxWidth: width,
        contentScale: contentScale,
        isRevealed: side == ViewCardsTileSide.back,
        showRevealButton: false,
      ),
      MultipleChoiceTemplate t => MultipleChoiceCard(
        controller: controller,
        template: t,
        maxWidth: width,
        contentScale: contentScale,
        isRevealed: true,
      ),
      FillInTheBlanksTemplate t => FillInTheBlanksCard(
        controller: controller,
        template: t,
        maxWidth: width,
        contentScale: contentScale,
        isRevealed: true,
      ),
      MatchMadnessTemplate t => MatchingTypeCard(
        controller: controller,
        template: t,
        maxWidth: width,
        contentScale: contentScale,
        isRevealed: true,
      ),
      IdentificationTemplate t => Surface(
        style: surfaceStyle.resolve(tokens),
        child: MarkdownText(
          data: t.promptText,
          mode: MarkdownTextMode.previewSelectable,
          baseTextStyle: promptTextStyle,
          contentScale: contentScale,
          resolveAttachmentUrl: t.resolveAttachmentUrl,
        ),
      ),
      WordScrambleTemplate t => Surface(
        style: surfaceStyle.resolve(tokens),
        child: MarkdownText(
          data: t.sentenceToScramble,
          mode: MarkdownTextMode.previewSelectable,
          baseTextStyle: promptTextStyle,
          contentScale: contentScale,
          resolveAttachmentUrl: t.resolveAttachmentUrl,
        ),
      ),
      _ => Surface(
        style: surfaceStyle.resolve(tokens),
        child: const Text('Template is Not Supported'),
      ),
    };
  }

  static StudyCard getPreviewStudyCard(
    CardTemplate? template, {
    bool isReversed = false,
  }) {
    final now = DateTime.now();
    return StudyCard(
      id: '__view_cards_preview__${template?.id ?? 'unknown'}_$isReversed',
      createdAt: now,
      updatedAt: now,
      templateId: template?.id ?? 'unknown',
      deckId: template?.deckId ?? 'unknown',
      isReversed: isReversed,
      template: template,
    );
  }
}
