// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_card.dart
// PURPOSE: A card within a deck — type metadata + associated content nodes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fsrs/fsrs.dart';
import 'package:uuid/uuid.dart';
import 'package:boo_mondai/models/card_type.dart';
import 'package:boo_mondai/models/fill_in_the_blank_segment.dart';
import 'package:boo_mondai/models/match_madness_pair.dart';
import 'package:boo_mondai/models/multiple_choice_option.dart';
import 'package:boo_mondai/models/note.dart';
import 'package:boo_mondai/models/question_type.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

/// A card inside a [Deck].
///
/// The card itself stores only type metadata. All presentable content
/// lives in its associated content nodes:
///
/// | [questionType]   | Content nodes present                                       |
/// |------------------|-------------------------------------------------------------|
/// | flashcard        | [notes] (1–2 depending on [cardType])                      |
/// | identification   | [notes] (frontText = prompt) + [identificationAnswer]       |
/// | multipleChoice   | [notes] (frontText = prompt) + [options]                   |
/// | fillInTheBlanks  | [segments] (1+ blanks)                                     |
/// | wordScramble     | [notes] (frontText = full sentence to reconstruct)         |
/// | matchMadness     | [pairs] only — no [notes]                                  |
class DeckCard {
  final String id;
  final String deckId;
  final CardType cardType;
  final QuestionType questionType;
  final int sortOrder;
  final DateTime createdAt;

  /// When non-null, this card was copied from another user's deck.
  /// Points to the original card's ID so the consumer can fetch and apply
  /// the author's latest changes via the "Update" button.
  final String? sourceCardId;

  /// Comma-separated acceptable answers for [QuestionType.identification].
  ///
  /// Matching is case-insensitive and trims whitespace around each entry.
  /// Example: `"dog, いぬ, inu"` accepts any of the three.
  /// Empty string for all other question types.
  final String identificationAnswer;

  /// Notes for this card. [CardType.both] produces two entries
  /// (isReverse=false and isReverse=true).
  /// Empty for [QuestionType.matchMadness].
  final List<Note> notes;

  /// Populated when [questionType] is [QuestionType.multipleChoice].
  final List<MultipleChoiceOption> options;

  /// Populated when [questionType] is [QuestionType.fillInTheBlanks].
  final List<FillInTheBlankSegment> segments;

  /// Populated when [questionType] is [QuestionType.matchMadness].
  final List<MatchMadnessPair> pairs;

  const DeckCard({
    required this.id,
    required this.deckId,
    this.cardType = CardType.normal,
    this.questionType = QuestionType.flashcard,
    required this.sortOrder,
    required this.createdAt,
    this.sourceCardId,
    this.identificationAnswer = '',
    this.notes = const [],
    this.options = const [],
    this.segments = const [],
    this.pairs = const [],
  });

  /// Creates a new [DeckCard] with generated UUIDs for the card and its
  /// sub-models (notes, options, segments, pairs).
  ///
  /// Handles the [CardType.both] → reverse-note logic and assigns
  /// [cardId] to every child automatically.
  factory DeckCard.create({
    required String deckId,
    CardType cardType = CardType.normal,
    QuestionType questionType = QuestionType.flashcard,
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
            ? options[i].copyWith(
                id: _uuid.v4(),
                cardId: cardId,
                displayOrder: i,
              )
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

  static const _uuid = Uuid();

  // ── Convenience getters (quiz-system compatibility) ──────────────────

  /// The primary (non-reverse) Note. Null for [QuestionType.matchMadness].
  Note? get primaryNote => notes.where((n) => !n.isReverse).firstOrNull;

  /// The question prompt shown to the learner.
  String get question => primaryNote?.frontText ?? '';

  /// The answer text from the primary note (used by [QuestionType.flashcard]).
  /// For [QuestionType.identification] use [identificationAnswer] instead.
  String get answer => primaryNote?.backText ?? '';

  /// Front image URL from the primary note.
  String? get questionImageUrl => primaryNote?.frontImageUrl;

  /// Back image URL from the primary note.
  String? get answerImageUrl => primaryNote?.backImageUrl;

  // ── Answer checking ──────────────────────────────────────────────────

  /// Accepted answers for [QuestionType.flashcard] — back text split on commas,
  /// trimmed, lower-cased.
  List<String> get acceptedAnswers =>
      answer.split(',').map((a) => a.trim().toLowerCase()).toList();

  /// Accepted answers for [QuestionType.identification] — [identificationAnswer]
  /// split on commas, trimmed, lower-cased, empty entries removed.
  List<String> get acceptedIdentificationAnswers => identificationAnswer
      .split(',')
      .map((a) => a.trim().toLowerCase())
      .where((a) => a.isNotEmpty)
      .toList();

  /// Returns true if [userAnswer] is correct for this card's [questionType].
  ///
  /// - flashcard       → comma-separated match in Note.backText
  /// - identification  → comma-separated match in [identificationAnswer]
  /// - multipleChoice  → matches a correct [MultipleChoiceOption] by id or text
  /// - fillInTheBlanks → any segment's [correctAnswer] matches
  /// - wordScramble    → exact case-insensitive match against the full sentence
  /// - matchMadness    → always false (matching handled by the game UI)
  bool checkAnswer(String userAnswer) {
    final trimmed = userAnswer.trim().toLowerCase();
    return switch (questionType) {
      QuestionType.flashcard => acceptedAnswers.contains(trimmed),
      QuestionType.identification => acceptedIdentificationAnswers.contains(
        trimmed,
      ),
      QuestionType.multipleChoice => options.any(
        (o) =>
            o.isCorrect &&
            (o.id == userAnswer.trim() ||
                o.optionText.trim().toLowerCase() == trimmed),
      ),
      QuestionType.fillInTheBlanks => segments.any(
        (s) => s.checkAnswer(userAnswer),
      ),
      QuestionType.wordScramble => trimmed == question.trim().toLowerCase(),
      QuestionType.matchMadness => false,
    };
  }

  // TODO: Turn into dart_mappable
  // ── Serialisation ────────────────────────────────────────────────────

  factory DeckCard.fromJson(Map<String, dynamic> json) => DeckCard(
    id: json['id'] as String,
    deckId: json['deck_id'] as String,
    cardType: CardType.fromString(json['card_type'] as String?),
    questionType: QuestionType.fromString(json['question_type'] as String?),
    sortOrder: json['sort_order'] as int? ?? 0,
    createdAt: DateTime.parse(json['created_at'] as String),
    sourceCardId: json['source_card_id'] as String?,
    identificationAnswer: json['identification_answer'] as String? ?? '',
    notes: (json['notes'] as List<dynamic>? ?? [])
        .map((n) => Note.fromJson(Map<String, dynamic>.from(n as Map)))
        .toList(),
    options: (json['mc_options'] as List<dynamic>? ?? [])
        .map(
          (o) => MultipleChoiceOption.fromJson(
            Map<String, dynamic>.from(o as Map),
          ),
        )
        .toList(),
    segments: (json['fitb_segments'] as List<dynamic>? ?? [])
        .map(
          (s) => FillInTheBlankSegment.fromJson(
            Map<String, dynamic>.from(s as Map),
          ),
        )
        .toList(),
    pairs: (json['mm_pairs'] as List<dynamic>? ?? [])
        .map(
          (p) => MatchMadnessPair.fromJson(Map<String, dynamic>.from(p as Map)),
        )
        .toList(),
  );

  /// Serialises only the columns that belong to the `deck_cards` table.
  /// Use this when writing to Supabase.
  Map<String, dynamic> toJson() => {
    'id': id,
    'deck_id': deckId,
    'card_type': cardType.toJson(),
    'question_type': questionType.toJson(),
    'sort_order': sortOrder,
    'created_at': createdAt.toIso8601String(),
    if (sourceCardId != null) 'source_card_id': sourceCardId,
    'identification_answer': identificationAnswer.isEmpty
        ? null
        : identificationAnswer,
  };

  /// Serialises the full card — including nested content nodes — for Hive cache.
  /// The nested lists use the same keys as the Supabase join response so
  /// [fromJson] can deserialise both sources without branching.
  Map<String, dynamic> toCacheJson() => {
    ...toJson(),
    'notes': notes.map((n) => n.toJson()).toList(),
    'mc_options': options.map((o) => o.toJson()).toList(),
    'fitb_segments': segments.map((s) => s.toJson()).toList(),
    'mm_pairs': pairs.map((p) => p.toJson()).toList(),
  };

  DeckCard copyWith({
    String? id,
    String? deckId,
    CardType? cardType,
    QuestionType? questionType,
    int? sortOrder,
    DateTime? createdAt,
    Object? sourceCardId = _sentinel,
    String? identificationAnswer,
    List<Note>? notes,
    List<MultipleChoiceOption>? options,
    List<FillInTheBlankSegment>? segments,
    List<MatchMadnessPair>? pairs,
  }) => DeckCard(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    cardType: cardType ?? this.cardType,
    questionType: questionType ?? this.questionType,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    sourceCardId: sourceCardId == _sentinel
        ? this.sourceCardId
        : sourceCardId as String?,
    identificationAnswer: identificationAnswer ?? this.identificationAnswer,
    notes: notes ?? this.notes,
    options: options ?? this.options,
    segments: segments ?? this.segments,
    pairs: pairs ?? this.pairs,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckCard && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'DeckCard(id: $id, type: ${questionType.toJson()}, question: $question)';
}

// Sentinel so copyWith can explicitly set sourceCardId to null.
const Object _sentinel = Object();
