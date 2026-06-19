import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonVariant,
        CardTemplate,
        ChipTone,
        FillInTheBlanksCard,
        FillInTheBlanksTemplate,
        FlashcardBackSide,
        FlashcardFrontSide,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchMadnessTemplate,
        MarkdownText,
        MultipleChoiceCard,
        MultipleChoiceTemplate,
        PhysicalCard,
        PhysicalCardSide,
        StudyCard,
        WordScrambleTemplate,
        MatchingTypeCard,
        chipStyle,
        useCubeController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

enum ViewCardSide { front, back }

class ViewCardTile extends HookWidget {
  const ViewCardTile.template({
    required this.template,
    this.width = 280,
    this.initialSide = ViewCardSide.front,
    this.allowFlip = true,
    super.key,
  }) : studyCard = null,
       assert(width > 0);

  const ViewCardTile.studyCard({
    required this.studyCard,
    this.width = 280,
    this.initialSide = ViewCardSide.front,
    this.allowFlip = true,
    super.key,
  }) : template = null,
       assert(width > 0);

  final CardTemplate? template;
  final StudyCard? studyCard;
  final double width;
  final ViewCardSide initialSide;
  final bool allowFlip;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedTemplate = template ?? studyCard?.template;
    final resolvedStudyCard = studyCard ?? _previewStudyCard(resolvedTemplate);
    final labels = _buildLabels(
      resolvedTemplate: resolvedTemplate,
      studyCard: resolvedStudyCard,
    );

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: tokens.studyCardAspectRatio,
            child: _ScaledCardText(
              width: width,
              child: _buildPreview(
                context,
                template: resolvedTemplate,
                studyCard: resolvedStudyCard,
                width: width,
                side: initialSide,
                allowFlip: allowFlip,
              ),
            ),
          ),
          if (labels.isNotEmpty) ...[
            SizedBox(height: tokens.spaceLayoutGapSm),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final label in labels.take(3))
                  ChipTheme(
                    data: chipStyle.resolve(tokens, const [ChipTone.ghost]),
                    child: Chip(
                      label: Text(label),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class ViewCardsReversibleGroup extends StatelessWidget {
  const ViewCardsReversibleGroup.template({
    required this.template,
    this.tileWidth = 260,
    super.key,
  }) : frontCard = null,
       backCard = null;

  const ViewCardsReversibleGroup.studyCards({
    required this.frontCard,
    required this.backCard,
    this.tileWidth = 260,
    super.key,
  }) : template = null;

  final CardTemplate? template;
  final StudyCard? frontCard;
  final StudyCard? backCard;
  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spaceLayoutPadding),
      decoration: BoxDecoration(
        color: tokens.colorMuted,
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm),
      ),
      child: Wrap(
        spacing: tokens.spaceLayoutGapLg,
        runSpacing: tokens.spaceLayoutGapLg,
        alignment: WrapAlignment.center,
        children: [
          if (template != null) ...[
            ViewCardTile.template(
              template: template!,
              width: tileWidth,
              initialSide: ViewCardSide.front,
              allowFlip: false,
            ),
            ViewCardTile.template(
              template: template!,
              width: tileWidth,
              initialSide: ViewCardSide.back,
              allowFlip: false,
            ),
          ] else ...[
            ViewCardTile.studyCard(
              studyCard: frontCard!,
              width: tileWidth,
              initialSide: ViewCardSide.front,
              allowFlip: false,
            ),
            ViewCardTile.studyCard(
              studyCard: backCard!,
              width: tileWidth,
              initialSide: ViewCardSide.back,
              allowFlip: false,
            ),
          ],
        ],
      ),
    );
  }
}

Widget _buildPreview(
  BuildContext context, {
  required CardTemplate? template,
  required StudyCard? studyCard,
  required double width,
  required ViewCardSide side,
  required bool allowFlip,
}) {
  if (template == null) {
    return const _UnknownTemplatePreview(label: 'Missing template');
  }

  return switch (template) {
    FlashcardTemplate t =>
      allowFlip
          ? _FlashcardPreview(
              template: t,
              studyCard: studyCard ?? _previewStudyCard(template),
              width: width,
            )
          : _FlashcardStaticPreview(
              template: t,
              studyCard:
                  studyCard ??
                  _previewStudyCard(
                    template,
                    isReversed: side == ViewCardSide.back,
                  ),
              side: side,
              width: width,
            ),
    MultipleChoiceTemplate t => MultipleChoiceCard.preview(
      template: t,
      maxWidth: width,
    ),
    FillInTheBlanksTemplate t => FillInTheBlanksCard.preview(
      template: t,
      maxWidth: width,
    ),
    MatchMadnessTemplate t => MatchingTypeCard.preview(
      template: t,
      maxWidth: width,
    ),
    IdentificationTemplate t => _PromptPreview(prompt: t.promptText),
    WordScrambleTemplate t => _PromptPreview(prompt: t.sentenceToScramble),
    _ => _UnknownTemplatePreview(label: template.runtimeType.toString()),
  };
}

class _FlashcardPreview extends HookWidget {
  const _FlashcardPreview({
    required this.template,
    required this.studyCard,
    required this.width,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final double width;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useCubeController(
      width: width,
      height: width / tokens.studyCardAspectRatio,
      depth: 10,
      perspective: 0.001,
    );

    useEffect(() {
      controller.showBack(studyCard.isReversed, animated: false);
      return null;
    }, [controller, studyCard.isReversed]);

    return Stack(
      children: [
        PhysicalCard(
          controller: controller,
          front: FlashcardFrontSide.preview(
            template: template,
            studyCard: studyCard,
            maxWidth: width,
          ),
          back: FlashcardBackSide(
            template: template,
            studyCard: studyCard,
            maxWidth: width,
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: Tooltip(
            message: 'Flip card',
            child: Button.iconSmall(
              icon: Icons.flip,
              variant: ButtonVariant.flat,
              onPressed: () => controller.flip(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FlashcardStaticPreview extends StatelessWidget {
  const _FlashcardStaticPreview({
    required this.template,
    required this.studyCard,
    required this.side,
    required this.width,
  });

  final FlashcardTemplate template;
  final StudyCard studyCard;
  final ViewCardSide side;
  final double width;

  @override
  Widget build(BuildContext context) {
    return switch (side) {
      ViewCardSide.front => FlashcardFrontSide.preview(
        template: template,
        studyCard: studyCard,
        maxWidth: width,
      ),
      ViewCardSide.back => FlashcardBackSide(
        template: template,
        studyCard: studyCard,
        maxWidth: width,
      ),
    };
  }
}

class _PromptPreview extends StatelessWidget {
  const _PromptPreview({required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return PhysicalCardSide(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: MarkdownText(data: prompt),
        ),
      ),
    );
  }
}

class _UnknownTemplatePreview extends StatelessWidget {
  const _UnknownTemplatePreview({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return PhysicalCardSide(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(label, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class _ScaledCardText extends StatelessWidget {
  const _ScaledCardText({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final scale = (width / tokens.studyCardWidth).clamp(0.8, 1.15).toDouble();

    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: child,
    );
  }
}

StudyCard _previewStudyCard(CardTemplate? template, {bool isReversed = false}) {
  return StudyCard(
    id: '__view_cards_preview__${template?.id ?? 'unknown'}_$isReversed',
    templateId: template?.id ?? 'unknown',
    deckId: template?.deckId ?? 'unknown',
    isReversed: isReversed,
    template: template,
  );
}

List<String> _buildLabels({
  required CardTemplate? resolvedTemplate,
  required StudyCard? studyCard,
}) {
  final labelsByKey = <String, String>{};

  void addLabel(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    labelsByKey.putIfAbsent(trimmed.toLowerCase(), () => trimmed);
  }

  for (final tag in resolvedTemplate?.tags ?? const []) {
    addLabel(tag.name);
  }

  for (final tag in studyCard?.personalTags ?? const []) {
    addLabel(tag.name);
  }

  return labelsByKey.values.take(3).toList();
}
