// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/card_type.dart
// PURPOSE: Enum — controls whether a card generates one or two Notes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'card_type.mapper.dart';

/// Whether the card is reviewed in one direction or both.
///
/// - [normal]   → one Note (front→back only)
/// - [reversed] → one Note flagged is_reverse=true (back→front only)
/// - [both]     → two Notes: one forward + one reversed
///
/// Only [QuestionType.flashcard] supports [reversed] / [both].
@MappableEnum()
enum CardType { normal, reversed, both }
