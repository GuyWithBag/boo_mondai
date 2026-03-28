// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/editor_types.dart
// PURPOSE: Typedefs and helper functions for deck editor data transformations
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.dart';

typedef McOpt = ({String text, bool isCorrect});
typedef Pair = ({String term, String match});

// ── Module-level data helpers ─────────────────────────────────────

List<MultipleChoiceOption> buildOptions(List<McOpt> opts) => [
  for (var i = 0; i < opts.length; i++)
    if (opts[i].text.trim().isNotEmpty)
      MultipleChoiceOption(
        id: '',
        cardId: '',
        optionText: opts[i].text.trim(),
        isCorrect: opts[i].isCorrect,
        displayOrder: i,
      ),
];

/// Splits [raw] on commas, trims whitespace, drops empty entries.
List<String> splitFitbAnswers(String raw) =>
    raw.split(',').map((a) => a.trim()).where((a) => a.isNotEmpty).toList();

List<FillInTheBlankSegment> buildSegments(String sentence, String answersRaw) {
  final s = sentence.trim();
  if (s.isEmpty) return [];
  final answers = splitFitbAnswers(answersRaw);
  if (answers.isEmpty) return [];
  final sl = s.toLowerCase();
  return [
    for (final a in answers)
      if (sl.contains(a.toLowerCase()))
        FillInTheBlankSegment(
          id: '',
          cardId: '',
          fullText: s,
          blankStart: sl.indexOf(a.toLowerCase()),
          blankEnd: sl.indexOf(a.toLowerCase()) + a.length,
          correctAnswer: a,
        ),
  ];
}

List<MatchMadnessPair> buildPairs(List<Pair> ps) => [
  for (var i = 0; i < ps.length; i++)
    if (ps[i].term.trim().isNotEmpty && ps[i].match.trim().isNotEmpty)
      MatchMadnessPair(
        id: '',
        cardId: '',
        term: ps[i].term.trim(),
        match: ps[i].match.trim(),
        isAutoPicked: false,
        displayOrder: i,
      ),
];
