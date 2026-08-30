// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/match_madness_pair.dart
// PURPOSE: One term↔match pair for a MATCH_MADNESS template
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/services/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'match_madness_pair.dto.mapper.dart';

/// A single term↔match pair for a [MatchMadnessTemplate].
///
/// [sourceTemplateId] is set when the pair was automatically picked from
/// another template in the same deck ([isAutoPicked] = true).
/// When the researcher manually creates the pair, [sourceTemplateId] is null.
@MappableClass()
class MatchMadnessPair with MatchMadnessPairMappable {
  final String id;
  final String templateId; // <-- CHANGED from cardId
  final String? sourceTemplateId; // <-- CHANGED from sourceCardId
  final String term;
  final String match;
  final bool isAutoPicked;
  final int displayOrder;

  const MatchMadnessPair({
    required this.id,
    required this.templateId, // <-- CHANGED
    this.sourceTemplateId, // <-- CHANGED
    required this.term,
    required this.match,
    this.isAutoPicked = false, // Default applied here instead of fromJson
    this.displayOrder = 0, // Default applied here instead of fromJson
  });

  factory MatchMadnessPair.createDummy({
    String? id,
    String templateId = '',
    int displayOrder = 0,
  }) {
    return MatchMadnessPair(
      id: id ?? uuid.v7(),
      templateId: templateId,
      term: '',
      match: '',
      displayOrder: displayOrder,
    );
  }
}
