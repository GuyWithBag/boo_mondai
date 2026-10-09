import 'package:boo_mondai/lib.barrel.dart'
    show
        MatchingTypeTemplate,
        StudySessionCardStageController,
        AppTokens,
        ButtonColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        MarkdownText,
        MarkdownAttachmentUrlResolver,
        MarkdownTextMode,
        MarkdownHelper,
        PhysicalCard,
        ScaleHelper,
        Button,
        AlignedScrollView,
        usePhysicalCardController,
        PhysicalCardController;
import 'package:boo_mondai/ui/study_session.card_stage/stages/matching_type/controllers/matching_type.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MatchingTypeCard extends SignalHookWidget {
  const MatchingTypeCard({
    super.key,
    required this.template,
    this.cardStageController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final MatchingTypeTemplate template;
  final StudySessionCardStageController? cardStageController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final matchingTypeController = useMemoized(
      () => MatchingTypeController(
        template: template,
        cardStageController: cardStageController,
      ),
      [template.id, cardStageController],
    );
    useEffect(() => matchingTypeController.dispose, [matchingTypeController]);
    final effectiveIsRevealed =
        isRevealed || cardStageController?.isRevealed.value == true;

    final eyebrowStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.heavy,
        TextColor.muted,
      ]),
      contentScale,
    );
    final itemTextStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.label,
        TextWeight.body,
        TextColor.baseline,
      ]),
      contentScale,
    );
    final gap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapMd,
      contentScale,
    );
    final columnGap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapSm,
      contentScale,
    );
    final padding = ScaleHelper.getScaledEdgeInsets(
      EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      contentScale,
    );

    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;
    final resolveAttachmentUrl = MarkdownHelper.resolveTemplateAttachmentUrl(
      template,
    );

    return PhysicalCard(
      controller: physicalCardController,
      padding: EdgeInsets.zero,
      front: AlignedScrollView(
        verticallyCentered: template.verticallyCentered,
        padding: padding,
        child: Column(
          spacing: gap,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Match the pairs'.toUpperCase(),
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            Row(
              spacing: columnGap,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _MatchingColumn(
                    items: matchingTypeController.leftItems.value,
                    controller: matchingTypeController,
                    locked: effectiveIsRevealed,
                    itemTextStyle: itemTextStyle,
                    contentScale: contentScale,
                    resolveAttachmentUrl: resolveAttachmentUrl,
                  ),
                ),
                Expanded(
                  child: _MatchingColumn(
                    items: matchingTypeController.rightItems.value,
                    controller: matchingTypeController,
                    locked: effectiveIsRevealed,
                    itemTextStyle: itemTextStyle,
                    contentScale: contentScale,
                    resolveAttachmentUrl: resolveAttachmentUrl,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchingColumn extends SignalWidget {
  const _MatchingColumn({
    required this.items,
    required this.controller,
    required this.locked,
    required this.itemTextStyle,
    required this.contentScale,
    required this.resolveAttachmentUrl,
  });

  final List<MatchingTypeItem> items;
  final MatchingTypeController controller;
  final bool locked;
  final TextStyle itemTextStyle;
  final double contentScale;
  final MarkdownAttachmentUrlResolver resolveAttachmentUrl;

  @override
  Widget build(BuildContext context) {
    final gap = ScaleHelper.getScaledValue(10.h, contentScale);

    return Column(
      spacing: gap,
      children: [
        for (final item in items)
          SizedBox(
            width: double.infinity,
            child: Button(
              elevated: false,
              contentScale: contentScale,
              selected: controller.isSelected(item),
              variants: [..._itemVariants(item)],
              mainAxisAlignment: MainAxisAlignment.center,
              onPressed: locked || controller.isMatched(item)
                  ? null
                  : () => controller.select(item),
              child: MarkdownText(
                data: item.value.text,
                mode: MarkdownTextMode.previewSelectable,
                baseTextStyle: itemTextStyle,
                contentScale: contentScale,
                resolveAttachmentUrl: resolveAttachmentUrl,
                imageConstraints: const BoxConstraints(
                  maxWidth: 96,
                  maxHeight: 96,
                ),
                audioConstraints: const BoxConstraints(maxWidth: 160),
              ),
            ),
          ),
      ],
    );
  }

  List<Object> _itemVariants(MatchingTypeItem item) {
    if (controller.isMatched(item)) {
      return const [ButtonColor.success];
    }
    if (controller.isIncorrect(item)) {
      return const [ButtonColor.error];
    }
    if (controller.isSelected(item)) {
      return const [ButtonColor.primary];
    }
    return const [ButtonColor.baseline];
  }
}
