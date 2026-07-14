import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplate,
        ChipTone,
        FillInTheBlanksCard,
        FillInTheBlanksTemplate,
        FlashcardCard,
        FlashcardTemplate,
        IdentificationTemplate,
        MatchMadnessTemplate,
        MarkdownText,
        MarkdownTextMode,
        MultipleChoiceCard,
        MultipleChoiceTemplate,
        PhysicalCard,
        PhysicalCardController,
        StudyCard,
        WordScrambleTemplate,
        MatchingTypeCard,
        chipStyle,
        ViewCardsTileSide;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardsTile extends StatelessWidget {
  const ViewCardsTile.template({
    required this.template,
    this.width = 280,
    this.initialSide = ViewCardsTileSide.front,
    this.allowFlip = true,
    this.controller,
    super.key,
  }) : studyCard = null,
       assert(width > 0);

  const ViewCardsTile.studyCard({
    required this.studyCard,
    this.width = 280,
    this.initialSide = ViewCardsTileSide.front,
    this.allowFlip = true,
    this.controller,
    super.key,
  }) : template = null,
       assert(width > 0);

  final CardTemplate? template;
  final StudyCard? studyCard;
  final double width;
  final ViewCardsTileSide initialSide;
  final bool allowFlip;
  final PhysicalCardController? controller;

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
                studyCard: studyCard,
                width: width,
                side: initialSide,
                allowFlip: allowFlip,
                controller: controller,
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

  Widget _buildPreview(
    BuildContext context, {
    required CardTemplate? template,
    required StudyCard? studyCard,
    required double width,
    required ViewCardsTileSide side,
    required bool allowFlip,
    required PhysicalCardController? controller,
  }) {
    if (template == null) {
      return _UnknownTemplatePreview(
        label: 'Missing template',
        controller: controller,
      );
    }

    return switch (template) {
      FlashcardTemplate t => FlashcardCard(
        controller: controller,
        template: t,
        studyCard:
            studyCard ??
            _previewStudyCard(
              template,
              isReversed: side == ViewCardsTileSide.back,
            ),
        maxWidth: width,
        isRevealed: side == ViewCardsTileSide.back,
        showRevealButton: false,
        showFlipButton: allowFlip,
      ),
      MultipleChoiceTemplate t => MultipleChoiceCard(
        controller: controller,
        template: t,
        maxWidth: width,
        isRevealed: true,
      ),
      FillInTheBlanksTemplate t => FillInTheBlanksCard(
        controller: controller,
        template: t,
        maxWidth: width,
        isRevealed: true,
      ),
      MatchMadnessTemplate t => MatchingTypeCard(
        controller: controller,
        template: t,
        maxWidth: width,
        isRevealed: true,
      ),
      IdentificationTemplate t => _PromptPreview(
        controller: controller,
        prompt: t.promptText,
        template: t,
      ),
      WordScrambleTemplate t => _PromptPreview(
        controller: controller,
        prompt: t.sentenceToScramble,
        template: t,
      ),
      _ => _UnknownTemplatePreview(
        label: template.runtimeType.toString(),
        controller: controller,
      ),
    };
  }
}

class _PromptPreview extends StatelessWidget {
  const _PromptPreview({
    required this.prompt,
    required this.template,
    this.controller,
  });

  final String prompt;
  final CardTemplate template;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    return PhysicalCard(
      controller: controller,
      front: Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: MarkdownText(
            data: prompt,
            mode: MarkdownTextMode.previewSelectable,
            resolveAttachmentUrl: template.resolveAttachmentUrl,
          ),
        ),
      ),
    );
  }
}

class _UnknownTemplatePreview extends StatelessWidget {
  const _UnknownTemplatePreview({required this.label, this.controller});

  final String label;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    return PhysicalCard(
      controller: controller,
      front: Center(
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
