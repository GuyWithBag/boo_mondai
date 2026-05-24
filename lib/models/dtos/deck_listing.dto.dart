// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_listing.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'deck_listing.dto.mapper.dart';

@MappableClass()
class DeckListing with DeckListingMappable {
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

  final DateTime updatedAt;
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
    required this.deckId,
  });
}
