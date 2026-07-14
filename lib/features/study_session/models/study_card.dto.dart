// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/study_cards.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/cards/models/card_template.dto.dart';
import 'package:boo_mondai/features/decks/models/deck.dto.dart';
import 'package:boo_mondai/features/tags/models/tag.dto.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show MutableEntity, MutableEntityCopyWith, MutableEntityMapper;
import 'package:dart_mappable/dart_mappable.dart';

part 'study_card.dto.mapper.dart';

@MappableClass()
class StudyCard with StudyCardMappable implements MutableEntity {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final String templateId;
  final bool isReversed;
  final String deckId;

  // Added to support Supabase joins with user_study_cards_tags
  // Note: Only the logged-in user will ever get data populated here due to RLS!
  final List<Tag> personalTags;
  final CardTemplate? template;
  final Deck? deck;

  const StudyCard({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.templateId,
    this.isReversed = false,
    required this.deckId,
    this.personalTags = const [],
    this.template,
    this.deck,
  });
}
