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
  final String description;
  final String targetLanguage;
  final bool isPremade;
  final bool isPublic;
  final int cardCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Deck({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.targetLanguage,
    required this.isPremade,
    required this.isPublic,
    required this.cardCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Deck.fromJson(Map<String, dynamic> json) => Deck(
        id: json['id'] as String,
        creatorId: json['creator_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        targetLanguage: json['target_language'] as String,
        isPremade: json['is_premade'] as bool? ?? false,
        isPublic: json['is_public'] as bool? ?? true,
        cardCount: json['card_count'] as int? ?? 0,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'creator_id': creatorId,
        'title': title,
        'description': description,
        'target_language': targetLanguage,
        'is_premade': isPremade,
        'is_public': isPublic,
        'card_count': cardCount,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  Deck copyWith({
    String? id,
    String? creatorId,
    String? title,
    String? description,
    String? targetLanguage,
    bool? isPremade,
    bool? isPublic,
    int? cardCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Deck(
        id: id ?? this.id,
        creatorId: creatorId ?? this.creatorId,
        title: title ?? this.title,
        description: description ?? this.description,
        targetLanguage: targetLanguage ?? this.targetLanguage,
        isPremade: isPremade ?? this.isPremade,
        isPublic: isPublic ?? this.isPublic,
        cardCount: cardCount ?? this.cardCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Deck && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Deck(id: $id, title: $title, cardCount: $cardCount)';
}
