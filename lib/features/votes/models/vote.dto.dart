// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_vote.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'vote.dto.mapper.dart';

@MappableClass()
class Vote with VoteMappable {
  final String contentId;
  final DateTime createdAt;
  final bool isPositive;

  const Vote({
    required this.contentId,
    required this.createdAt,
    required this.isPositive,
  });
}
