// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/review_card.dart
// PURPOSE: The testable instance of a template, tracked by FSRS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'review_card.mapper.dart';

@MappableClass()
class ReviewCard with ReviewCardMappable {
  final String id; // The UNIQUE ID for FSRS
  final String templateId; // Points to the CardTemplate in the database
  final bool isReversed; // Tells the UI which side to show
  final String deckId;

  const ReviewCard({
    required this.id,
    required this.templateId,
    this.isReversed = false,
    required this.deckId,
  });
}
