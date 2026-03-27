// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/card_type.dart
// PURPOSE: Enum — controls whether a card generates one or two Notes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Whether the card is reviewed in one direction or both.
///
/// - [normal]     → one Note (front→back only)
/// - [reversible] → one Note flagged is_reverse=true (back→front only)
/// - [both]       → two Notes: one forward + one reversed
///
/// Constraint: only [readAndSelect] and [listenAndType] can be
/// reversible. All other question types must use [normal].
enum CardType {
  normal,
  reversible,
  both;

  static CardType fromString(String? s) => switch (s) {
        'reversible' => reversible,
        'both' => both,
        _ => normal,
      };

  String toJson() => name; // 'normal' | 'reversible' | 'both'
}
