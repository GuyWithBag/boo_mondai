// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/card_type.dart
// PURPOSE: Enum — controls whether a card generates one or two Notes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Whether the card is reviewed in one direction or both.
///
/// - [normal]   → one Note (front→back only)
/// - [reversed] → one Note flagged is_reverse=true (back→front only)
/// - [both]     → two Notes: one forward + one reversed
///
/// Only [QuestionType.flashcard] supports [reversed] / [both].
enum CardType {
  normal,
  reversed,
  both;

  static CardType fromString(String? s) => switch (s) {
        'reversed' => reversed,
        // legacy alias kept for data migrated before the rename
        'reversible' => reversed,
        'both' => both,
        _ => normal,
      };

  String toJson() => name; // 'normal' | 'reversed' | 'both'
}
