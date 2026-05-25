// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_favorite.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'deck_favorite.dto.mapper.dart';

@MappableClass()
class DeckFavorite with DeckFavoriteMappable {
  final String deckId;
  final String userId;
  final DateTime createdAt;
  final Deck? deck;
  final CachedProfile? userProfile;

  const DeckFavorite({
    required this.deckId,
    required this.userId,
    required this.createdAt,
    this.deck,
    this.userProfile,
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
