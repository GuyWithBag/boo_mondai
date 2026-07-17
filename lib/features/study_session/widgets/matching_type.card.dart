import 'package:boo_mondai/lib.barrel.dart'
    show
        MatchMadnessTemplate,
        StudySessionCardStageController,
        AppTokens,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        MarkdownText,
        MarkdownTextMode,
        PhysicalCard,
        ScaleHelper,
        Button,
        usePhysicalCardController,
        PhysicalCardController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class MatchingTypeCard extends HookWidget {
  const MatchingTypeCard({
    super.key,
    required this.template,
    this.interactionsController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final MatchMadnessTemplate template;
  final StudySessionCardStageController? interactionsController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
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
    final itemGap = ScaleHelper.getScaledValue(14.h, contentScale);
    final padding = ScaleHelper.getScaledEdgeInsets(
      EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      contentScale,
    );
    final terms = template.pairs.map((pair) => pair.term).toList();
    final matches = template.pairs.map((pair) => pair.match).toList();
    final selectedMatch = useState<String?>(null);
    final matchedItems = useState<Set<String>>({});
    final effectiveIsRevealed =
        isRevealed || interactionsController?.isRevealed == true;
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;

    useEffect(() {
      selectedMatch.value = null;
      matchedItems.value = {};
      return null;
    }, [template.id, interactionsController]);

    void handleMatchTap(String item) {
      if (effectiveIsRevealed) return;
      final selected = selectedMatch.value;
      if (selected == null) {
        selectedMatch.value = item;
        return;
      }

      final isPair = template.pairs.any(
        (pair) =>
            (pair.term == selected && pair.match == item) ||
            (pair.match == selected && pair.term == item),
      );

      if (isPair) {
        final nextMatched = {...matchedItems.value, selected, item};
        matchedItems.value = nextMatched;
        if (nextMatched.length == template.pairs.length * 2) {
          interactionsController?.revealWithAnswer('Matched all pairs');
        }
      }

      selectedMatch.value = null;
    }

    return PhysicalCard(
      controller: physicalCardController,
      padding: EdgeInsets.zero,
      front: Padding(
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
                  child: _MatchColumn(
                    items: terms,
                    selectedMatch: selectedMatch.value,
                    matchedItems: matchedItems.value,
                    isRevealed: effectiveIsRevealed,
                    textStyle: itemTextStyle,
                    itemGap: itemGap,
                    contentScale: contentScale,
                    onItemPressed: handleMatchTap,
                  ),
                ),
                Expanded(
                  child: _MatchColumn(
                    items: matches,
                    selectedMatch: selectedMatch.value,
                    matchedItems: matchedItems.value,
                    isRevealed: effectiveIsRevealed,
                    textStyle: itemTextStyle,
                    itemGap: itemGap,
                    contentScale: contentScale,
                    onItemPressed: handleMatchTap,
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

class _MatchColumn extends StatelessWidget {
  const _MatchColumn({
    required this.items,
    required this.selectedMatch,
    required this.matchedItems,
    required this.isRevealed,
    required this.textStyle,
    required this.itemGap,
    required this.contentScale,
    required this.onItemPressed,
  });

  final List<String> items;
  final String? selectedMatch;
  final Set<String> matchedItems;
  final bool isRevealed;
  final TextStyle textStyle;
  final double itemGap;
  final double contentScale;
  final ValueChanged<String>? onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) ...[
          _MatchButton(
            value: item,
            selected: selectedMatch == item,
            matched: isRevealed ? false : matchedItems.contains(item),
            textStyle: textStyle,
            contentScale: contentScale,
            onPressed: isRevealed || onItemPressed == null
                ? null
                : () => onItemPressed!(item),
          ),
          if (item != items.last) SizedBox(height: itemGap),
        ],
      ],
    );
  }
}

class _MatchButton extends StatelessWidget {
  const _MatchButton({
    required this.value,
    required this.selected,
    required this.matched,
    required this.textStyle,
    required this.contentScale,
    required this.onPressed,
  });

  final String value;
  final bool selected;
  final bool matched;
  final TextStyle textStyle;
  final double contentScale;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: matched,
      child: Opacity(
        opacity: matched ? 0 : 1,
        child: SizedBox(
          width: double.infinity,
          child: Button(
            selected: selected,
            contentScale: contentScale,
            mainAxisAlignment: MainAxisAlignment.center,
            onPressed: onPressed,
            child: MarkdownText(
              data: value,
              mode: MarkdownTextMode.preview,
              baseTextStyle: textStyle,
              contentScale: contentScale,
            ),
          ),
        ),
      ),
    );
  }
}
