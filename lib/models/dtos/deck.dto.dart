import 'package:boo_mondai/models/dto.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart'; // 1. Import UUID

part 'deck.dto.mapper.dart';

// Initialize UUID instance outside the class for reuse
const _uuid = Uuid();

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
  final String targetLanguage;
  final List<String> tags;
  final bool isPremade;
  final bool isPublic;
  final bool isPublished;
  final bool isEditable;
  final int cardCount;
  final String version;
  final int buildNumber;
  final String? sourceDeckId;
  final String? sourceAuthorId;

  // Standard constructor for mapping/deserialization
  const Deck({
    required this.id,
    required this.userId,
    required this.title,
    this.shortDescription = '',
    this.longDescription = '',
    required this.targetLanguage,
    this.tags = const [],
    this.isPremade = false,
    required this.isPublic,
    this.isEditable = true,
    required this.cardCount,
    this.version = '1.0.0',
    this.buildNumber = 1,
    required this.createdAt,
    required this.updatedAt,
    this.sourceDeckId,
    this.sourceAuthorId,
    required this.isPublished,
  });

  /// Use this initializer for creating NEW decks in your UI/Logic.
  /// It automatically generates the ID and Timestamps.
  factory Deck.createNow({
    required String userId,
    required String title,
    required String targetLanguage,
    bool? isPremade,
    required bool isPublic,
    required bool isPublished,
    int cardCount = 0,
    String? shortDescription,
    String? longDescription,
    List<String>? tags,
    bool? isEditable,
    String? version,
    String? sourceDeckId,
    String? sourceAuthorId,
  }) {
    final now = DateTime.now();
    return Deck(
      id: _uuid.v4(), // 2. Generate UUID
      userId: userId,
      title: title,
      targetLanguage: targetLanguage,
      isPremade: isPremade ?? false,
      isPublic: isPublic,
      isPublished: isPublished,
      cardCount: cardCount,
      createdAt: now, // 3. Set current time
      updatedAt: now, // 3. Set current time
      shortDescription: shortDescription ?? '',
      longDescription: longDescription ?? '',
      tags: tags ?? const [],
      isEditable: isEditable ?? true,
      version: version ?? '1.0.0',
      sourceDeckId: sourceDeckId,
      sourceAuthorId: sourceAuthorId,
    );
  }
}
