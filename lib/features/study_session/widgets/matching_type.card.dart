import 'package:boo_mondai/lib.barrel.dart'
    show
        MatchMadnessTemplate,
        StudySessionCardStageController,
        AppTokens,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        PhysicalCardSide,
        TactileButton;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class MatchingTypeCard extends HookWidget {
  const MatchingTypeCard({
    super.key,
    required this.template,
    required this.interactionsController,
  });

  final MatchMadnessTemplate template;
  final StudySessionCardStageController interactionsController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final terms = template.pairs.map((pair) => pair.term).toList();
    final matches = template.pairs.map((pair) => pair.match).toList();
    final selectedMatch = useState<String?>(null);
    final matchedItems = useState<Set<String>>({});

    useEffect(() {
      selectedMatch.value = null;
      matchedItems.value = {};
      return null;
    }, [template.id, interactionsController]);

    void handleMatchTap(String item) {
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
          interactionsController.revealWithAnswer('Matched all pairs');
        }
      }

      selectedMatch.value = null;
    }

    return PhysicalCardSide(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Match the pairs'.toUpperCase(),
            textAlign: TextAlign.center,
            style: appTextStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextTone.muted,
            ]),
          ),
          SizedBox(height: 40.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MatchColumn(
                  items: terms,
                  selectedMatch: selectedMatch.value,
                  matchedItems: matchedItems.value,
                  onItemPressed: handleMatchTap,
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: _MatchColumn(
                  items: matches,
                  selectedMatch: selectedMatch.value,
                  matchedItems: matchedItems.value,
                  onItemPressed: handleMatchTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MatchColumn extends StatelessWidget {
  const _MatchColumn({
    required this.items,
    required this.selectedMatch,
    required this.matchedItems,
    required this.onItemPressed,
  });

  final List<String> items;
  final String? selectedMatch;
  final Set<String> matchedItems;
  final ValueChanged<String> onItemPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) ...[
          _MatchButton(
            value: item,
            selected: selectedMatch == item,
            matched: matchedItems.contains(item),
            onPressed: () => onItemPressed(item),
          ),
          if (item != items.last) SizedBox(height: 14.h),
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
    required this.onPressed,
  });

  final String value;
  final bool selected;
  final bool matched;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: matched,
      child: Opacity(
        opacity: matched ? 0 : 1,
        child: SizedBox(
          width: double.infinity,
          child: TactileButton(
            selected: selected,
            mainAxisAlignment: MainAxisAlignment.center,
            onPressed: onPressed,
            child: Text(value, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
