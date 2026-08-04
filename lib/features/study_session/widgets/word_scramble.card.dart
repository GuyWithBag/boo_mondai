import 'dart:math';

import 'package:boo_mondai/lib.barrel.dart'
    show
        AlignedScrollView,
        AppTokens,
        Button,
        ButtonColor,
        ButtonVariant,
        MarkdownText,
        MarkdownTextMode,
        PhysicalCard,
        PhysicalCardController,
        ScaleHelper,
        StudySessionCardStageController,
        TextColor,
        TextSize,
        TextWeight,
        WordScrambleTemplate,
        textStyle,
        usePhysicalCardController,
        ScrambledWord;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class WordScrambleCard extends HookWidget {
  const WordScrambleCard({
    super.key,
    required this.template,
    this.interactionsController,
    this.isRevealed = false,
    this.maxWidth,
    this.contentScale = 1,
    this.controller,
  });

  final WordScrambleTemplate template;
  final StudySessionCardStageController? interactionsController;
  final bool isRevealed;
  final double? maxWidth;
  final double contentScale;
  final PhysicalCardController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final words = useMemoized(
      () => _scrambleWords(template.sentenceToScramble, template.id),
      [template.id, template.sentenceToScramble],
    );
    final placed = useState<List<ScrambledWord>>([]);
    final remaining = useState<List<ScrambledWord>>(words);
    final effectiveIsRevealed =
        isRevealed || interactionsController?.isRevealed == true;
    final fallbackPhysicalCardController = usePhysicalCardController(
      context,
      width: maxWidth,
    );
    final physicalCardController = controller ?? fallbackPhysicalCardController;
    final eyebrowStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.heavy,
        TextColor.muted,
      ]),
      contentScale,
    );
    final markdownTextStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.label,
        TextWeight.body,
        TextColor.baseline,
      ]),
      contentScale,
    );
    final padding = ScaleHelper.getScaledEdgeInsets(
      EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      contentScale,
    );
    final gap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapMd,
      contentScale,
    );

    useEffect(() {
      placed.value = [];
      remaining.value = words;
      interactionsController?.setAnswer(null);
      interactionsController?.setCanReveal(false);
      return null;
    }, [template.id, words, interactionsController]);

    void syncAnswer(List<ScrambledWord> nextPlaced) {
      final answer = nextPlaced.map((word) => word.value).join(' ');
      interactionsController?.setAnswer(answer.isEmpty ? null : answer);
      interactionsController?.setCanReveal(answer.trim().isNotEmpty);
    }

    void moveToPlaced(ScrambledWord word) {
      if (effectiveIsRevealed) return;
      final nextRemaining = [...remaining.value]..remove(word);
      final nextPlaced = [...placed.value, word];
      remaining.value = nextRemaining;
      placed.value = nextPlaced;
      syncAnswer(nextPlaced);
    }

    void moveToRemaining(ScrambledWord word) {
      if (effectiveIsRevealed) return;
      final nextPlaced = [...placed.value]..remove(word);
      final nextRemaining = [...remaining.value, word];
      placed.value = nextPlaced;
      remaining.value = nextRemaining;
      syncAnswer(nextPlaced);
    }

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
              'Unscramble the sentence'.toUpperCase(),
              textAlign: TextAlign.center,
              style: eyebrowStyle,
            ),
            _WordArea(
              label: 'Your answer',
              words: effectiveIsRevealed
                  ? _sentenceWords(template.sentenceToScramble)
                  : placed.value,
              emptyText: 'Tap words below to build the sentence.',
              textStyle: markdownTextStyle,
              contentScale: contentScale,
              onWordPressed: effectiveIsRevealed ? null : moveToRemaining,
            ),
            if (!effectiveIsRevealed)
              _WordArea(
                label: 'Word bank',
                words: remaining.value,
                emptyText: 'All words used.',
                textStyle: markdownTextStyle,
                contentScale: contentScale,
                color: ButtonColor.muted,
                onWordPressed: moveToPlaced,
              ),
          ],
        ),
      ),
    );
  }

  List<ScrambledWord> _scrambleWords(String sentence, String seed) {
    final words = _sentenceWords(sentence);
    if (words.length < 2) return words;
    final shuffled = [...words];
    shuffled.shuffle(Random(_stableSeed(seed)));
    if (_sameOrder(shuffled, words)) {
      final first = shuffled.removeAt(0);
      shuffled.add(first);
    }
    return shuffled;
  }

  List<ScrambledWord> _sentenceWords(String sentence) {
    final parts = sentence
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    return [
      for (final entry in parts.asMap().entries)
        ScrambledWord(id: entry.key, value: entry.value),
    ];
  }

  int _stableSeed(String value) {
    return value.codeUnits.fold<int>(0, (seed, unit) => seed * 31 + unit);
  }

  bool _sameOrder(List<ScrambledWord> a, List<ScrambledWord> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }
}

class _WordArea extends StatelessWidget {
  const _WordArea({
    required this.label,
    required this.words,
    required this.emptyText,
    required this.textStyle,
    required this.contentScale,
    required this.onWordPressed,
    this.color = ButtonColor.baseline,
  });

  final String label;
  final List<ScrambledWord> words;
  final String emptyText;
  final TextStyle textStyle;
  final double contentScale;
  final ValueChanged<ScrambledWord>? onWordPressed;
  final ButtonColor color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final gap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapSm,
      contentScale,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        SizedBox(height: gap),
        if (words.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: ScaleHelper.getScaledValue(12.h, contentScale),
            ),
            child: Text(
              emptyText,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          )
        else
          Wrap(
            alignment: WrapAlignment.center,
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final word in words)
                Button(
                  contentScale: contentScale,
                  variants: [color, ButtonVariant.flat],
                  onPressed: onWordPressed == null
                      ? null
                      : () => onWordPressed!(word),
                  child: MarkdownText(
                    data: word.value,
                    mode: MarkdownTextMode.previewSelectable,
                    baseTextStyle: textStyle,
                    contentScale: contentScale,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
