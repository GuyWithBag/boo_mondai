import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplate,
        FillInTheBlanksCard,
        FillInTheBlanksTemplate,
        FlashcardCard,
        FlashcardTemplate,
        IdentificationCard,
        IdentificationTemplate,
        MatchingTypeTemplate,
        MatchingTypeCard,
        MultipleChoiceCard,
        MultipleChoiceTemplate,
        PhysicalCardController,
        StudyCard,
        ViewCardsTileSide,
        WordScrambleCard,
        WordScrambleTemplate,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

abstract class ViewCardsHelper {
  static Widget getCorrespondingViewCard(
    AppTokens tokens, {
    required CardTemplate template,
    required double width,
    required ViewCardsTileSide side,
    required PhysicalCardController? controller,
    double contentScale = 1,
  }) {
    return switch (template) {
      FlashcardTemplate t => FlashcardCard(
        controller: controller,
        template: t,
        studyCard: _getPreviewStudyCard(
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
      MatchingTypeTemplate t => MatchingTypeCard(
        controller: controller,
        template: t,
        maxWidth: width,
        contentScale: contentScale,
        isRevealed: true,
      ),
      IdentificationTemplate t => IdentificationCard(
        controller: controller,
        template: t,
        maxWidth: width,
        contentScale: contentScale,
        isRevealed: true,
      ),
      WordScrambleTemplate t => WordScrambleCard(
        controller: controller,
        template: t,
        maxWidth: width,
        contentScale: contentScale,
        isRevealed: true,
      ),
      _ => Surface(
        style: surfaceStyle.resolve(tokens),
        child: const Text('Template is Not Supported'),
      ),
    };
  }

  static StudyCard _getPreviewStudyCard(
    CardTemplate template, {
    bool isReversed = false,
  }) {
    final now = DateTime.now();
    return StudyCard(
      id: '__view_cards_preview__${template.id}_$isReversed',
      createdAt: now,
      updatedAt: now,
      templateId: template.id,
      deckId: template.deckId,
      isReversed: isReversed,
    );
  }
}
