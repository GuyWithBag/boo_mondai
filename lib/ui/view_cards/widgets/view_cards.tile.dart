import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        CardTemplate,
        ChipTone,
        FlashcardTemplate,
        PhysicalCardController,
        ScaleHelper,
        usePhysicalCardController,
        chipStyle,
        ViewCardsTileSide,
        ViewCardsHelper;
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
  }) : assert(width > 0);

  final CardTemplate template;
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
    final labels = _buildLabels(template);
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

    void onPressed(BuildContext context, CardTemplate template) {
      context.push('/view-cards/${template.deckId}');
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
                  template: template,
                  width: width,
                  side: initialSide,
                  controller: effectiveController,
                  contentScale: contentScale,
                ),
                if (flippable && template is FlashcardTemplate)
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

    if (!editable) return tile;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPressed(context, template),
      child: tile,
    );
  }
}

List<String> _buildLabels(CardTemplate template) {
  final labelsByKey = <String, String>{};

  void addLabel(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    labelsByKey.putIfAbsent(trimmed.toLowerCase(), () => trimmed);
  }

  for (final tag in template.tags) {
    addLabel(tag.name);
  }

  return labelsByKey.values.take(3).toList();
}
