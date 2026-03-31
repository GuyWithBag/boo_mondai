// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck.dart
// PURPOSE: Deck data model — a collection of vocabulary cards
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class Deck {
  final String id;
  final String creatorId;
  final String title;

  /// One-line summary shown in list tiles and the online browser.
  final String shortDescription;

  /// Full description shown on the deck detail sheet and browser page.
  final String longDescription;

  final String targetLanguage;

  /// Searchable tags for the online deck browser (e.g. ['jlpt-n5', 'animals']).
  final List<String> tags;

  final bool isPremade;
  // TODO: Change this to isPublished
  final bool isPublic;

  /// When true the deck is locked — consumers cannot edit or delete its cards.
  /// Intended for capstone-study premade decks.
  final bool isUneditable;

  final int cardCount;

  /// Semantic version string displayed to users (e.g. "1.0.0").
  /// Creator-editable.
  final String version;

  /// Auto-incrementing build number. Incremented by the server on every save.
  /// Not directly editable by the user.
  final int buildNumber;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// When non-null, this deck was copied from another public deck.
  /// Points to the original deck's ID so the UI can show "Original by …".
  final String? sourceDeckId;

  /// The user ID of the original deck's creator. Populated from a Supabase
  /// join on [sourceDeckId] — null when [sourceDeckId] is null or when
  /// loaded from Hive cache.
  final String? sourceDeckCreatorId;

  /// When true the deck is hidden from the public online browser.
  /// Used by researchers to distribute premade/uneditable decks via codes
  /// instead of the public browser.
  final bool hiddenInBrowser;

  const Deck({
    required this.id,
    required this.creatorId,
    required this.title,
    this.shortDescription = '',
    this.longDescription = '',
    required this.targetLanguage,
    this.tags = const [],
    required this.isPremade,
    required this.isPublic,
    this.isUneditable = false,
    required this.cardCount,
    this.version = '1.0.0',
    this.buildNumber = 1,
    required this.createdAt,
    required this.updatedAt,
    this.sourceDeckId,
    this.sourceDeckCreatorId,
    this.hiddenInBrowser = false,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    // Supabase join: source_deck:decks!source_deck_id(creator_id)
    // Supabase may return the join as a List or a Map depending on the
    // foreign-key direction it infers — handle both.
    final sourceDeckRaw = json['source_deck'];
    final sourceDeckJoin = sourceDeckRaw is Map<String, dynamic>
        ? sourceDeckRaw
        : (sourceDeckRaw is List && sourceDeckRaw.isNotEmpty)
        ? sourceDeckRaw.first as Map<String, dynamic>?
        : null;

    return Deck(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      title: json['title'] as String,
      shortDescription: json['short_description'] as String? ?? '',
      longDescription: json['long_description'] as String? ?? '',
      targetLanguage: json['target_language'] as String,
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((t) => t as String)
          .toList(),
      isPremade: json['is_premade'] as bool? ?? false,
      isPublic: json['is_public'] as bool? ?? true,
      isUneditable: json['is_uneditable'] as bool? ?? false,
      cardCount: json['card_count'] as int? ?? 0,
      version: json['version'] as String? ?? '1.0.0',
      buildNumber: json['build_number'] as int? ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sourceDeckId: json['source_deck_id'] as String?,
      sourceDeckCreatorId: sourceDeckJoin?['creator_id'] as String?,
      hiddenInBrowser: json['hidden_in_browser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'creator_id': creatorId,
    'title': title,
    'short_description': shortDescription,
    'long_description': longDescription,
    'target_language': targetLanguage,
    'tags': tags,
    'is_premade': isPremade,
    'is_public': isPublic,
    'is_uneditable': isUneditable,
    'hidden_in_browser': hiddenInBrowser,
    'card_count': cardCount,
    'version': version,
    'build_number': buildNumber,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    if (sourceDeckId != null) 'source_deck_id': sourceDeckId,
  };

  Deck copyWith({
    String? id,
    String? creatorId,
    String? title,
    String? shortDescription,
    String? longDescription,
    String? targetLanguage,
    List<String>? tags,
    bool? isPremade,
    bool? isPublic,
    bool? isUneditable,
    bool? hiddenInBrowser,
    int? cardCount,
    String? version,
    int? buildNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? sourceDeckId = _sentinel,
    Object? sourceDeckCreatorId = _sentinel,
  }) => Deck(
    id: id ?? this.id,
    creatorId: creatorId ?? this.creatorId,
    title: title ?? this.title,
    shortDescription: shortDescription ?? this.shortDescription,
    longDescription: longDescription ?? this.longDescription,
    targetLanguage: targetLanguage ?? this.targetLanguage,
    tags: tags ?? this.tags,
    isPremade: isPremade ?? this.isPremade,
    isPublic: isPublic ?? this.isPublic,
    isUneditable: isUneditable ?? this.isUneditable,
    hiddenInBrowser: hiddenInBrowser ?? this.hiddenInBrowser,
    cardCount: cardCount ?? this.cardCount,
    version: version ?? this.version,
    buildNumber: buildNumber ?? this.buildNumber,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sourceDeckId: sourceDeckId == _sentinel
        ? this.sourceDeckId
        : sourceDeckId as String?,
    sourceDeckCreatorId: sourceDeckCreatorId == _sentinel
        ? this.sourceDeckCreatorId
        : sourceDeckCreatorId as String?,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Deck && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Deck(id: $id, title: $title, v$version+$buildNumber)';
}

const Object _sentinel = Object();
