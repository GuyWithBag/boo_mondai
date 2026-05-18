// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_listing.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'deck_listing.dto.mapper.dart';

@MappableClass()
class DeckListing with DeckListingMappable implements DTO {
  // We do not need a primary key 'id' field here because
  // the ID is always identical to the parent Deck's ID.
  final String deckId;
  final int upvotesCount;
  final int downvotesCount;
  final int downloadsCount;
  final int favoritesCount;
  final int forksCount;
  final int commentsCount;
  final int reviewsCount;
  final int reportsCount;

  // Store the snippets as simple maps to match Supabase JSONB
  final List<Map<String, dynamic>> featuredCards;
  final List<String> featuredImages;

  @override
  final String id;
  @override
  final DateTime updatedAt;
  @override
  final DateTime createdAt;

  const DeckListing({
    this.upvotesCount = 0,
    this.downvotesCount = 0,
    this.downloadsCount = 0,
    this.favoritesCount = 0,
    this.forksCount = 0,
    this.commentsCount = 0,
    this.reviewsCount = 0,
    this.reportsCount = 0,
    this.featuredCards = const [],
    this.featuredImages = const [],
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.deckId,
  });
}
