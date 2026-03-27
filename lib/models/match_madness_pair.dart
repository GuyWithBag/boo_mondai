// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/match_madness_pair.dart
// PURPOSE: One term↔match pair for a MATCH_MADNESS card
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// A single term↔match pair for a [QuestionType.matchMadness] card.
///
/// [sourceCardId] is set when the pair was automatically picked from
/// another card in the same deck ([isAutoPicked] = true).
/// When the researcher manually creates the pair, [sourceCardId] is null.
class MatchMadnessPair {
  final String id;
  final String cardId;
  final String? sourceCardId;
  final String term;
  final String match;
  final bool isAutoPicked;
  final int displayOrder;

  const MatchMadnessPair({
    required this.id,
    required this.cardId,
    this.sourceCardId,
    required this.term,
    required this.match,
    required this.isAutoPicked,
    required this.displayOrder,
  });

  factory MatchMadnessPair.fromJson(Map<String, dynamic> json) =>
      MatchMadnessPair(
        id: json['id'] as String,
        cardId: json['card_id'] as String,
        sourceCardId: json['source_card_id'] as String?,
        term: json['term'] as String,
        match: json['match'] as String,
        isAutoPicked: json['is_auto_picked'] as bool? ?? false,
        displayOrder: json['display_order'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'card_id': cardId,
        'source_card_id': sourceCardId,
        'term': term,
        'match': match,
        'is_auto_picked': isAutoPicked,
        'display_order': displayOrder,
      };

  MatchMadnessPair copyWith({
    String? id,
    String? cardId,
    String? sourceCardId,
    String? term,
    String? match,
    bool? isAutoPicked,
    int? displayOrder,
  }) =>
      MatchMadnessPair(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        sourceCardId: sourceCardId ?? this.sourceCardId,
        term: term ?? this.term,
        match: match ?? this.match,
        isAutoPicked: isAutoPicked ?? this.isAutoPicked,
        displayOrder: displayOrder ?? this.displayOrder,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchMadnessPair &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MatchMadnessPair(term: $term, match: $match)';
}
