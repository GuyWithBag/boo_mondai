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
  final String profileId;
  final DateTime createdAt;
  final Deck? deck;
  final CachedProfile? userProfile;

  const DeckFavorite({
    required this.deckId,
    required this.profileId,
    required this.createdAt,
    this.deck,
    this.userProfile,
  });

  factory DeckFavorite.createNow({
    required String deckId,
    required String profileId,
  }) {
    return DeckFavorite(
      deckId: deckId,
      profileId: profileId,
      createdAt: DateTime.now(),
    );
  }

  factory DeckFavorite.createDummy({
    String deckId = '',
    String profileId = '',
  }) {
    return DeckFavorite(
      deckId: deckId,
      profileId: profileId,
      createdAt: DateTime.now(),
    );
  }

  String get compositeId => '${deckId}_$profileId';
}
