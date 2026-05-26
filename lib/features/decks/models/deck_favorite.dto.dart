// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_favorite.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/profile/models/cached_profile.dart';
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
