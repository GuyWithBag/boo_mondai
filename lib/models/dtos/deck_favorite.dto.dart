// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_favorite.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'deck_favorite.dto.mapper.dart';

@MappableClass()
class DeckFavorite with DeckFavoriteMappable {
  final String deckId;
  final String userId;
  final DateTime createdAt;

  const DeckFavorite({
    required this.deckId,
    required this.userId,
    required this.createdAt,
  });

  factory DeckFavorite.createNow({
    required String deckId,
    required String userId,
  }) {
    return DeckFavorite(
      deckId: deckId,
      userId: userId,
      createdAt: DateTime.now(),
    );
  }

  String get compositeId => '${deckId}_$userId';
}
