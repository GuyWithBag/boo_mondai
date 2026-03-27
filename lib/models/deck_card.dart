// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_card.dart
// PURPOSE: A card within a deck — type metadata + associated content nodes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/card_type.dart';
import 'package:boo_mondai/models/fill_in_the_blank_segment.dart';
import 'package:boo_mondai/models/match_madness_pair.dart';
import 'package:boo_mondai/models/multiple_choice_option.dart';
import 'package:boo_mondai/models/note.dart';
import 'package:boo_mondai/models/question_type.dart';

/// A card inside a [Deck].
///
/// The card itself stores only type metadata. All presentable content
/// lives in its associated content nodes:
///
/// | [questionType]         | Content nodes present                          |
/// |------------------------|------------------------------------------------|
/// | readAndSelect          | [notes] (1–2 depending on [cardType])          |
/// | listenAndType          | [notes] with audio URLs                        |
/// | multipleChoice         | [notes] (prompt) + [options]                   |
/// | fillInTheBlanks        | [segments] (one blank each)                    |
/// | readAndComplete        | [segments] (multiple blanks)                   |
/// | matchMadness           | [pairs] only — no [notes]                      |
class DeckCard {
  final String id;
  final String deckId;
  final CardType cardType;
  final QuestionType questionType;
  final int sortOrder;
  final DateTime createdAt;

  /// Notes for this card. [CardType.both] produces two entries
  /// (isReverse=false and isReverse=true).
  final List<Note> notes;

  /// Populated when [questionType] is [QuestionType.multipleChoice].
  final List<MultipleChoiceOption> options;

  /// Populated when [questionType] is [QuestionType.fillInTheBlanks]
  /// or [QuestionType.readAndComplete].
  final List<FillInTheBlankSegment> segments;

  /// Populated when [questionType] is [QuestionType.matchMadness].
  final List<MatchMadnessPair> pairs;

  const DeckCard({
    required this.id,
    required this.deckId,
    this.cardType = CardType.normal,
    this.questionType = QuestionType.readAndSelect,
    required this.sortOrder,
    required this.createdAt,
    this.notes = const [],
    this.options = const [],
    this.segments = const [],
    this.pairs = const [],
  });

  // ── Convenience getters (quiz-system compatibility) ──────────────────

  /// The primary (non-reverse) Note. Null for [QuestionType.matchMadness].
  Note? get primaryNote =>
      notes.where((n) => !n.isReverse).firstOrNull;

  /// The question prompt shown to the learner.
  String get question => primaryNote?.frontText ?? '';

  /// The accepted answer text (comma-separated for readAndSelect).
  String get answer => primaryNote?.backText ?? '';

  /// Front image URL from the primary note.
  String? get questionImageUrl => primaryNote?.frontImageUrl;

  /// Back image URL from the primary note.
  String? get answerImageUrl => primaryNote?.backImageUrl;

  // ── Answer checking ──────────────────────────────────────────────────

  /// Accepted answers for [QuestionType.readAndSelect] and
  /// [QuestionType.listenAndType] — back text split on commas,
  /// trimmed, lower-cased.
  List<String> get acceptedAnswers =>
      answer.split(',').map((a) => a.trim().toLowerCase()).toList();

  /// Returns true if [userAnswer] is correct for this card's [questionType].
  ///
  /// - readAndSelect / listenAndType → comma-separated match in [answer]
  /// - multipleChoice → matches a correct [MultipleChoiceOption] by id or text
  /// - fillInTheBlanks / readAndComplete → any segment's [correctAnswer] matches
  /// - matchMadness → always false (matching handled by the game UI)
  bool checkAnswer(String userAnswer) {
    final trimmed = userAnswer.trim().toLowerCase();
    return switch (questionType) {
      QuestionType.readAndSelect ||
      QuestionType.listenAndType =>
        acceptedAnswers.contains(trimmed),
      QuestionType.multipleChoice => options.any(
          (o) =>
              o.isCorrect &&
              (o.id == userAnswer.trim() ||
                  o.optionText.trim().toLowerCase() == trimmed),
        ),
      QuestionType.fillInTheBlanks ||
      QuestionType.readAndComplete =>
        segments.any((s) => s.checkAnswer(userAnswer)),
      QuestionType.matchMadness => false,
    };
  }

  // ── Serialisation ────────────────────────────────────────────────────

  factory DeckCard.fromJson(Map<String, dynamic> json) => DeckCard(
        id: json['id'] as String,
        deckId: json['deck_id'] as String,
        cardType: CardType.fromString(json['card_type'] as String?),
        questionType:
            QuestionType.fromString(json['question_type'] as String?),
        sortOrder: json['sort_order'] as int? ?? 0,
        createdAt: DateTime.parse(json['created_at'] as String),
        notes: (json['notes'] as List<dynamic>? ?? [])
            .map((n) => Note.fromJson(n as Map<String, dynamic>))
            .toList(),
        options: (json['mc_options'] as List<dynamic>? ?? [])
            .map((o) =>
                MultipleChoiceOption.fromJson(o as Map<String, dynamic>))
            .toList(),
        segments: (json['fitb_segments'] as List<dynamic>? ?? [])
            .map((s) =>
                FillInTheBlankSegment.fromJson(s as Map<String, dynamic>))
            .toList(),
        pairs: (json['mm_pairs'] as List<dynamic>? ?? [])
            .map((p) =>
                MatchMadnessPair.fromJson(p as Map<String, dynamic>))
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
    List<Note>? notes,
    List<MultipleChoiceOption>? options,
    List<FillInTheBlankSegment>? segments,
    List<MatchMadnessPair>? pairs,
  }) =>
      DeckCard(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        cardType: cardType ?? this.cardType,
        questionType: questionType ?? this.questionType,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
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
