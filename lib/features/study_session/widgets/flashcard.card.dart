import 'package:boo_mondai/core/core.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        FlashcardTemplate,
        StudyCard,
        StudySessionCardStageController,
        StudySessionController,
        FlashcardFrontSide,
        FlashcardBackSide,
        PhysicalCard;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class FlashcardCard extends HookWidget {
  const FlashcardCard({
    super.key,
    required this.template,
    required this.studyCard,
    this.interactionsController,
    this.studySessionController,
    this.isRevealed = false,
    this.showRevealButton = true,
    this.showFlipButton = false,
    this.maxWidth,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final StudySessionCardStageController? interactionsController;
  final StudySessionController? studySessionController;
  final bool isRevealed;
  final bool showRevealButton;
  final bool showFlipButton;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final physicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
      perspective: 0.001,
    );
    final effectiveIsRevealed =
        isRevealed || interactionsController?.isRevealed == true;

    useEffect(() {
      physicalCardController.showBack(
        effectiveIsRevealed,
        animated: interactionsController != null,
      );
      return null;
    }, [physicalCardController, effectiveIsRevealed, interactionsController]);

    void reveal() {
      final interactionsController = this.interactionsController;
      final studySessionController = this.studySessionController;
      if (interactionsController == null || studySessionController == null) {
        return;
      }
      interactionsController.reveal(studySessionController);
    }

    return Stack(
      children: [
        PhysicalCard(
          controller: physicalCardController,
          onTap: interactionsController == null ? null : reveal,
          front: FlashcardFrontSide(
            template: template,
            studyCard: studyCard,
            showRevealButton:
                showRevealButton && interactionsController != null,
            onReveal: reveal,
          ),
          back: FlashcardBackSide(template: template, studyCard: studyCard),
        ),
        if (showFlipButton)
          Positioned(
            right: 8,
            bottom: 8,
            child: Tooltip(
              message: 'Flip card',
              child: Button.iconOnlySmall(
                icon: Icons.flip,
                tokens: tokens,
                onPressed: () => physicalCardController.flip(),
              ),
            ),
          ),
      ],
    );
  }
}
