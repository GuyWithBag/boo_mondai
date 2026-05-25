// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/dtos/deck.dto.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'deck.dto.mapper.dart';

@MappableClass()
class Deck with DeckMappable implements DTO {
  @override
  final String id;
  @override
  final DateTime updatedAt;
  @override
  final DateTime createdAt;

  final String userId;
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
    required this.userId,
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
    this.version = '1.0.0',
    this.buildNumber = 1,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.userProfile,
    this.listing,
  });

  factory Deck.createNow({
    required String userId,
    required String title,
    String? shortDescription,
    String? longDescription,
    String? coverImageUrl,
    String? sourceDeckId,
    VisibilityState visibilityState = VisibilityState.private,
    required bool isPublished,
    bool? isPremade,
    bool? isEditable,
    String? version,
    List<Tag>? tags,
  }) {
    final now = DateTime.now();
    return Deck(
      id: uuid.v7(),
      userId: userId,
      title: title,
      shortDescription: shortDescription ?? '',
      longDescription: longDescription ?? '',
      coverImageUrl: coverImageUrl,
      sourceDeckId: sourceDeckId,
      visibilityState: visibilityState,
      isPublished: isPublished,
      isPremade: isPremade ?? false,
      isEditable: isEditable ?? true,
      cardCount: 0,
      version: version ?? '1.0.0',
      buildNumber: 1,
      createdAt: now,
      updatedAt: now,
      tags: tags ?? const [],
      userProfile: null,
      listing: null,
    );
  }
}
