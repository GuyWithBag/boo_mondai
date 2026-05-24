// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_vote.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'deck_vote.dto.mapper.dart';

@MappableClass()
class DeckVote with DeckVoteMappable {
  final String deckId;
  final String userId;
  final int voteValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeckVote({
    required this.deckId,
    required this.userId,
    required this.voteValue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeckVote.createNow({
    required String deckId,
    required String userId,
    required int voteValue,
  }) {
    final now = DateTime.now();
    return DeckVote(
      deckId: deckId,
      userId: userId,
      voteValue: voteValue,
      createdAt: now,
      updatedAt: now,
    );
  }

  String get compositeId => '${deckId}_$userId';
}
