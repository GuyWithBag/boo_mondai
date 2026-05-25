// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/review_card.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'review_card.dto.mapper.dart';

@MappableClass()
class ReviewCard with ReviewCardMappable {
  final String id;
  final String templateId;
  final bool isReversed;
  final String deckId;

  // Added to support Supabase joins with user_review_card_tags
  // Note: Only the logged-in user will ever get data populated here due to RLS!
  final List<Tag> personalTags;
  final CardTemplate? template;
  final Deck? deck;

  const ReviewCard({
    required this.id,
    required this.templateId,
    this.isReversed = false,
    required this.deckId,
    this.personalTags = const [],
    this.template,
    this.deck,
  });
}
