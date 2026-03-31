// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/editor_types.dart
// PURPOSE: Typedefs and helper functions for deck editor data transformations
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/models.barrel.dart';

typedef McOpt = ({String text, bool isCorrect});
typedef Pair = ({String term, String match});

const _uuid = Uuid();

/// Pure function that builds a [DeckCard] in memory with no side effects.
/// Used by the editor page to create cards in local draft state.
DeckCard buildNewCard(
  String deckId, {
  required CardType cardType,
  required QuestionType questionType,
  int sortOrder = 0,
  String frontText = '',
  String backText = '',
  String? frontImageUrl,
  String? backImageUrl,
  String? frontAudioUrl,
  String? backAudioUrl,
  List<MultipleChoiceOption> options = const [],
  List<FillInTheBlankSegment> segments = const [],
  List<MatchMadnessPair> pairs = const [],
}) {
  final cardId = _uuid.v4();
  final now = DateTime.now();

  final newNote = Note(
    id: _uuid.v4(),
    cardId: cardId,
    frontText: frontText,
    backText: backText,
    frontImageUrl: frontImageUrl,
    backImageUrl: backImageUrl,
    frontAudioUrl: frontAudioUrl,
    backAudioUrl: backAudioUrl,
    isReverse: false,
    createdAt: now,
  );

  final builtNotes = <Note>[];
  if (!questionType.usesPairs) {
    builtNotes.add(newNote);
    if (cardType == CardType.both) {
      builtNotes.add(newNote.reverse());
    }
  }

  final builtOptions = [
    for (var i = 0; i < options.length; i++)
      options[i].id.isEmpty
          ? options[i].copyWith(id: _uuid.v4(), cardId: cardId, displayOrder: i)
          : options[i].copyWith(cardId: cardId, displayOrder: i),
  ];
  final builtSegments = [
    for (final seg in segments)
      seg.id.isEmpty
          ? seg.copyWith(id: _uuid.v4(), cardId: cardId)
          : seg.copyWith(cardId: cardId),
  ];
  final builtPairs = [
    for (var i = 0; i < pairs.length; i++)
      pairs[i].id.isEmpty
          ? pairs[i].copyWith(id: _uuid.v4(), cardId: cardId, displayOrder: i)
          : pairs[i].copyWith(cardId: cardId, displayOrder: i),
  ];

  return DeckCard(
    id: cardId,
    deckId: deckId,
    cardType: cardType,
    questionType: questionType,
    sortOrder: sortOrder,
    createdAt: now,
    notes: builtNotes,
    options: builtOptions,
    segments: builtSegments,
    pairs: builtPairs,
  );
}

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
