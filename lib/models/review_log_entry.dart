// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/review_log_entry.dart
// PURPOSE: FSRS review log entry for tracking review history
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class ReviewLogEntry {
  final String id;
  final String userId;
  final String cardId;
  final int rating; // 1=Again, 2=Hard, 3=Good, 4=Easy
  final int scheduledDays;
  final int elapsedDays;
  final DateTime review;
  final int state;

  const ReviewLogEntry({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.rating,
    required this.scheduledDays,
    required this.elapsedDays,
    required this.review,
    required this.state,
  });

  factory ReviewLogEntry.fromJson(Map<String, dynamic> json) =>
      ReviewLogEntry(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        cardId: json['card_id'] as String,
        rating: json['rating'] as int,
        scheduledDays: json['scheduled_days'] as int,
        elapsedDays: json['elapsed_days'] as int,
        review: DateTime.parse(json['review'] as String),
        state: json['state'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'card_id': cardId,
        'rating': rating,
        'scheduled_days': scheduledDays,
        'elapsed_days': elapsedDays,
        'review': review.toIso8601String(),
        'state': state,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewLogEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ReviewLogEntry(id: $id, cardId: $cardId, rating: $rating)';
}
