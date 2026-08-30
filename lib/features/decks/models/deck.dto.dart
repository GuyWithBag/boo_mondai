// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        CachedProfile,
        MutableEntity,
        DeckListing,
        Tag,
        VisibilityState,
        uuid,
        VisibilityStateMapper,
        MutableEntityMapper,
        CachedProfileMapper,
        TagMapper,
        DeckListingMapper,
        MutableEntityCopyWith,
        TagCopyWith,
        CachedProfileCopyWith,
        DeckListingCopyWith;
import 'package:dart_mappable/dart_mappable.dart';

part 'deck.dto.mapper.dart';

@MappableClass()
class Deck with DeckMappable implements MutableEntity {
  final String id;
  @override
  final DateTime updatedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime? purgeAfter;

  final String profileId;
  final String title;
  final String shortDescription;
  final String longDescription;

  // ── Visuals & Provenance ──
  final String? coverImageUrl;
  final String? sourceDeckId;

  final bool isPremade;
  final VisibilityState visibilityState;
  final bool isPublished;
  final bool isEditable;
  final int cardCount;
  final String version;
  final int buildNumber;

  final List<Tag> tags;

  // ── Joined Data (Populated by remote deck fetches) ──
  final CachedProfile? userProfile;

  // ── The Storefront Data (Populated when fetching from online browser) ──
  final DeckListing? listing;

  const Deck({
    required this.id,
    required this.profileId,
    required this.title,
    this.shortDescription = '',
    this.longDescription = '',
    this.coverImageUrl,
    this.sourceDeckId,
    this.isPremade = false,
    required this.visibilityState,
    required this.isPublished,
    this.isEditable = true,
    required this.cardCount,
    this.version = '0.1.0+1',
    this.buildNumber = 1,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.purgeAfter,
    this.tags = const [],
    this.userProfile,
    this.listing,
  });

  factory Deck.createNow({
    required String profileId,
    required String title,
    String? shortDescription,
    String? longDescription,
    String? coverImageUrl,
    String? sourceDeckId,
    VisibilityState visibilityState = VisibilityState.private,
    bool isPublished = false,
    bool isPremade = false,
    bool isEditable = true,
    String version = '0.1.0+1',
    List<Tag>? tags,
  }) {
    final now = DateTime.now();
    return Deck(
      id: uuid.v7(),
      profileId: profileId,
      title: title,
      shortDescription: shortDescription ?? '',
      longDescription: longDescription ?? '',
      coverImageUrl: coverImageUrl,
      sourceDeckId: sourceDeckId,
      visibilityState: visibilityState,
      isPublished: isPublished,
      isPremade: isPremade,
      isEditable: isEditable,
      cardCount: 0,
      version: version,
      buildNumber: 1,
      createdAt: now,
      updatedAt: now,
      tags: tags ?? const [],
      userProfile: null,
      listing: null,
    );
  }

  factory Deck.createDummy({
    String? id,
    String profileId = '',
    String title = '',
  }) {
    final now = DateTime.now();
    return Deck(
      id: id ?? uuid.v7(),
      profileId: profileId,
      title: title,
      visibilityState: VisibilityState.private,
      isPublished: false,
      cardCount: 0,
      createdAt: now,
      updatedAt: now,
    );
  }
}
