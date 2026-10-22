// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/models/mutable_entity.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Tag,
        TagCopyWith,
        TagMapper,
        VisibilityState,
        VisibilityStateMapper,
        uuid,
        MutableEntity;
import 'package:dart_mappable/dart_mappable.dart';

part 'deck.dto.mapper.dart';

@MappableClass()
class Deck with DeckMappable implements MutableEntity {
  final String id;
  final String profileId;
  @override
  final DateTime updatedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime? purgeAfter;

  final String title;
  final String shortDescription;
  final String longDescription;

  final String? coverImageUrl;
  final String? sourceDeckId;

  final bool isPremade;
  final VisibilityState visibilityState;
  final bool isPublished;
  final bool isEditable;
  final int cardTemplatesCount;
  final String version;
  final int buildNumber;

  final List<Tag> tags;

  const Deck({
    required this.id,
    required this.profileId,
    required this.title,
    this.shortDescription = '',
    this.longDescription = '',
    this.coverImageUrl,
    this.sourceDeckId,
    this.isPremade = false,
    this.visibilityState = VisibilityState.private,
    this.isPublished = false,
    this.isEditable = true,
    this.cardTemplatesCount = 0,
    this.version = '0.1.0+1',
    this.buildNumber = 1,
    this.tags = const [],
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    this.purgeAfter,
  });

  factory Deck.createDummy({
    String? id,
    String profileId = '',
    String title = '',
    String contentId = '',
  }) {
    return Deck(
      id: id ?? uuid.v7(),
      profileId: profileId,
      title: title,
      cardTemplatesCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
