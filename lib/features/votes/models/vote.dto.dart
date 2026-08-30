// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck_vote.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'vote.dto.mapper.dart';

@MappableClass()
class Vote with VoteMappable {
  final String contentId;
  final String profileId;
  final DateTime createdAt;
  final bool isPositive;

  const Vote({
    required this.contentId,
    required this.profileId,
    required this.createdAt,
    required this.isPositive,
  });

  String get compositeId => '${contentId}_$profileId';
}
