import 'package:boo_mondai/features/view_cards/view_cards.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        CardTemplate,
        ChipTone,
        FlashcardTemplate,
        PhysicalCardController,
        ScaleHelper,
        StudyCard,
        usePhysicalCardController,
        chipStyle,
        ViewCardsTileSide;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCardsTile extends HookWidget {
  const ViewCardsTile.template({
    required this.template,
    this.width = 280,
    this.initialSide = ViewCardsTileSide.front,
    this.flippable = true,
    this.editable = false,
    this.controller,
    super.key,
  }) : studyCard = null,
       assert(width > 0);

  const ViewCardsTile.studyCard({
    required this.studyCard,
    this.width = 280,
    this.initialSide = ViewCardsTileSide.front,
    this.flippable = true,
    this.editable = false,
    this.controller,
    super.key,
  }) : template = null,
       assert(width > 0);

  final CardTemplate? template;
  final StudyCard? studyCard;
  final double width;
  final ViewCardsTileSide initialSide;
  final bool flippable;
  final bool editable;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final fallbackController = usePhysicalCardController(
      context,
      width: width,
      perspective: 0.001,
    );
    final effectiveController = controller ?? fallbackController;
    final contentScale = ScaleHelper.getClampedSizeRatio(
      current: width,
      base: tokens.studyCardWidth,
      min: 0.2,
    );
    final resolvedTemplate = template ?? studyCard?.template;
    final resolvedStudyCard =
        studyCard ?? ViewCardsHelper.getPreviewStudyCard(resolvedTemplate);
    final labels = _buildLabels(
      resolvedTemplate: resolvedTemplate,
      studyCard: resolvedStudyCard,
    );
    final tileGap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapSm,
      contentScale,
    );
    final chipSpacing = ScaleHelper.getScaledValue(8, contentScale);
    final flipInset = ScaleHelper.getScaledValue(8, contentScale);
    final chipTheme = chipStyle.resolve(tokens, const [ChipTone.ghost]);
    final scaledChipLabelStyle = chipTheme.labelStyle == null
        ? null
        : ScaleHelper.getTextStyleWithScaledFontSize(
            chipTheme.labelStyle!,
            contentScale,
          );

    void onEditCardPressed(BuildContext context, CardTemplate template) {
      context.push(
        Uri(
          path: '/decks-local/${template.deckId}/edit',
          queryParameters: {'initialTemplateId': template.id},
        ).toString(),
      );
    }

    final tile = SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: tokens.studyCardAspectRatio,
            child: Stack(
              children: [
                ViewCardsHelper.getCorrespondingViewCard(
                  tokens,
                  template: resolvedTemplate,
                  studyCard: studyCard,
                  width: width,
                  side: initialSide,
                  controller: effectiveController,
                  contentScale: contentScale,
                ),
                if (resolvedTemplate != null &&
                    flippable &&
                    resolvedTemplate is FlashcardTemplate)
                  Positioned(
                    right: flipInset,
                    bottom: flipInset,
                    child: Tooltip(
                      message: 'Flip card',
                      child: Button.iconSmall(
                        icon: Icons.flip,
                        onPressed: effectiveController.flip,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (labels.isNotEmpty) ...[
            SizedBox(height: tileGap),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: chipSpacing,
              runSpacing: chipSpacing,
              children: [
                for (final label in labels.take(3))
                  ChipTheme(
                    data: chipTheme,
                    child: Chip(
                      label: Text(label),
                      labelStyle: scaledChipLabelStyle,
                      labelPadding: ScaleHelper.getScaledEdgeInsets(
                        const EdgeInsets.symmetric(horizontal: 4),
                        contentScale,
                      ),
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

    if (!editable || resolvedTemplate == null) return tile;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onEditCardPressed(context, resolvedTemplate),
      child: tile,
    );
  }
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
