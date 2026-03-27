// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/note.dart
// PURPOSE: Content node for a card — front/back text, audio, and image URLs
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Stores the presentable content of one side of a [DeckCard].
///
/// A [CardType.normal] card generates one Note ([isReverse] = false).
/// A [CardType.reversible] card generates one Note ([isReverse] = true).
/// A [CardType.both] card generates two Notes — one with each value of [isReverse].
///
/// [QuestionType.matchMadness] cards do NOT generate Notes.
class Note {
  final String id;
  final String cardId;
  final String frontText;
  final String backText;
  final String? frontAudioUrl;
  final String? backAudioUrl;
  final String? frontImageUrl;
  final String? backImageUrl;

  /// When true this Note is the reversed reading (back→front direction).
  final bool isReverse;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.cardId,
    required this.frontText,
    required this.backText,
    this.frontAudioUrl,
    this.backAudioUrl,
    this.frontImageUrl,
    this.backImageUrl,
    required this.isReverse,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        cardId: json['card_id'] as String,
        frontText: json['front_text'] as String? ?? '',
        backText: json['back_text'] as String? ?? '',
        frontAudioUrl: json['front_audio_url'] as String?,
        backAudioUrl: json['back_audio_url'] as String?,
        frontImageUrl: json['front_image_url'] as String?,
        backImageUrl: json['back_image_url'] as String?,
        isReverse: json['is_reverse'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'card_id': cardId,
        'front_text': frontText,
        'back_text': backText,
        'front_audio_url': frontAudioUrl,
        'back_audio_url': backAudioUrl,
        'front_image_url': frontImageUrl,
        'back_image_url': backImageUrl,
        'is_reverse': isReverse,
        'created_at': createdAt.toIso8601String(),
      };

  Note copyWith({
    String? id,
    String? cardId,
    String? frontText,
    String? backText,
    String? frontAudioUrl,
    String? backAudioUrl,
    String? frontImageUrl,
    String? backImageUrl,
    bool? isReverse,
    DateTime? createdAt,
  }) =>
      Note(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        frontText: frontText ?? this.frontText,
        backText: backText ?? this.backText,
        frontAudioUrl: frontAudioUrl ?? this.frontAudioUrl,
        backAudioUrl: backAudioUrl ?? this.backAudioUrl,
        frontImageUrl: frontImageUrl ?? this.frontImageUrl,
        backImageUrl: backImageUrl ?? this.backImageUrl,
        isReverse: isReverse ?? this.isReverse,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Note(cardId: $cardId, front: $frontText, reverse: $isReverse)';
}
