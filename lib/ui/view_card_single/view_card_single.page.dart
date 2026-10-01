import 'dart:math' as math;

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        Button,
        CardTemplate,
        CardTemplateController,
        FillInTheBlanksCard,
        FillInTheBlanksTemplate,
        FlashcardCard,
        FlashcardTemplate,
        IdentificationCard,
        IdentificationTemplate,
        MatchingTypeCard,
        MatchingTypeTemplate,
        MultipleChoiceCard,
        MultipleChoiceTemplate,
        Scaffold,
        ScaleHelper,
        StatusLayoutState,
        StudyCard,
        StudySessionCardStageController,
        ViewCardSingleController,
        WordScrambleCard,
        WordScrambleTemplate;
import 'package:flutter/material.dart' hide AppBar, Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardSinglePage extends SignalHookWidget {
  const ViewCardSinglePage({
    super.key,
    required this.templateId,
    this.initialTemplate,
  });

  final String templateId;
  final CardTemplate? initialTemplate;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => ViewCardSingleController(
        templateId: templateId,
        initialTemplate: initialTemplate,
      ),
      [templateId, initialTemplate],
    );
    useEffect(() => controller.dispose, [controller]);

    final tokens = context.themeTokens<AppTokens>();
    final template = controller.template.value;
    final cardStageController = controller.cardStageController.value;
    final previewStudyCard = controller.previewStudyCard.value;
    final error = controller.error.value;

    Widget body() {
      if (error != null) {
        return StatusLayoutState.exception(exception: error);
      }
      if (template == null ||
          cardStageController == null ||
          previewStudyCard == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = tokens.spaceScaffoldPadding * 2;
          final width = math.min(
            tokens.studyCardWidth,
            math.max(240.0, constraints.maxWidth - horizontalPadding),
          );
          final contentScale = ScaleHelper.getClampedSizeRatio(
            current: width,
            base: tokens.studyCardWidth,
            min: 0.2,
          );

          return Center(
            child: SizedBox(
              width: width,
              child: AspectRatio(
                aspectRatio: tokens.studyCardAspectRatio,
                child: _PreviewCard(
                  template: template,
                  previewStudyCard: previewStudyCard,
                  cardStageController: cardStageController,
                  width: width,
                  contentScale: contentScale,
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      scrollable: false,
      appBar: AppBar(
        title: 'Card Preview',
        actions: [
          Button.icon(
            tokens: tokens,
            icon: controller.isRevealed.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onPressed: cardStageController == null
                ? null
                : controller.toggleReveal,
          ),
        ],
      ),
      body: body(),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.template,
    required this.previewStudyCard,
    required this.cardStageController,
    required this.width,
    required this.contentScale,
  });

  final CardTemplate template;
  final StudyCard previewStudyCard;
  final StudySessionCardStageController<CardTemplateController>
  cardStageController;
  final double width;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    return switch (template) {
      FlashcardTemplate t => FlashcardCard(
        template: t,
        studyCard: previewStudyCard,
        cardStageController: cardStageController,
        maxWidth: width,
        contentScale: contentScale,
        showRevealButton: false,
      ),
      MultipleChoiceTemplate t => MultipleChoiceCard(
        template: t,
        cardStageController: cardStageController,
        maxWidth: width,
        contentScale: contentScale,
      ),
      FillInTheBlanksTemplate t => FillInTheBlanksCard(
        template: t,
        cardStageController: cardStageController,
        maxWidth: width,
        contentScale: contentScale,
      ),
      MatchingTypeTemplate t => MatchingTypeCard(
        template: t,
        cardStageController: cardStageController,
        maxWidth: width,
        contentScale: contentScale,
      ),
      IdentificationTemplate t => IdentificationCard(
        template: t,
        cardStageController: cardStageController,
        maxWidth: width,
        contentScale: contentScale,
      ),
      WordScrambleTemplate t => WordScrambleCard(
        template: t,
        cardStageController: cardStageController,
        maxWidth: width,
        contentScale: contentScale,
      ),
      _ => StatusLayoutState(
        icon: Icons.extension_off_outlined,
        title: 'Unsupported Card',
        message: 'This card template cannot be previewed yet.',
      ),
    };
  }
}
