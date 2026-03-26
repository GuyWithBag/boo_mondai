// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/fsrs_card_state.dart
// PURPOSE: Local FSRS card state — maps to the fsrs package Card object
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class FsrsCardState {
  final String id; // "{userId}_{cardId}"
  final String userId;
  final String cardId;
  final DateTime due;
  final double stability;
  final double difficulty;
  final int elapsedDays;
  final int scheduledDays;
  final int reps;
  final int lapses;
  final int state; // 0=new, 1=learning, 2=review, 3=relearning
  final DateTime? lastReview;

  const FsrsCardState({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.due,
    required this.stability,
    required this.difficulty,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.reps,
    required this.lapses,
    required this.state,
    this.lastReview,
  });

  bool get isDue => due.isBefore(DateTime.now()) || due.isAtSameMomentAs(DateTime.now());

  factory FsrsCardState.fromJson(Map<String, dynamic> json) => FsrsCardState(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        cardId: json['card_id'] as String,
        due: DateTime.parse(json['due'] as String),
        stability: (json['stability'] as num).toDouble(),
        difficulty: (json['difficulty'] as num).toDouble(),
        elapsedDays: json['elapsed_days'] as int,
        scheduledDays: json['scheduled_days'] as int,
        reps: json['reps'] as int,
        lapses: json['lapses'] as int,
        state: json['state'] as int,
        lastReview: json['last_review'] != null
            ? DateTime.parse(json['last_review'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'card_id': cardId,
        'due': due.toIso8601String(),
        'stability': stability,
        'difficulty': difficulty,
        'elapsed_days': elapsedDays,
        'scheduled_days': scheduledDays,
        'reps': reps,
        'lapses': lapses,
        'state': state,
        'last_review': lastReview?.toIso8601String(),
      };

  FsrsCardState copyWith({
    String? id,
    String? userId,
    String? cardId,
    DateTime? due,
    double? stability,
    double? difficulty,
    int? elapsedDays,
    int? scheduledDays,
    int? reps,
    int? lapses,
    int? state,
    DateTime? lastReview,
  }) =>
      FsrsCardState(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        cardId: cardId ?? this.cardId,
        due: due ?? this.due,
        stability: stability ?? this.stability,
        difficulty: difficulty ?? this.difficulty,
        elapsedDays: elapsedDays ?? this.elapsedDays,
        scheduledDays: scheduledDays ?? this.scheduledDays,
        reps: reps ?? this.reps,
        lapses: lapses ?? this.lapses,
        state: state ?? this.state,
        lastReview: lastReview ?? this.lastReview,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsCardState &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FsrsCardState(id: $id, due: $due, state: $state, reps: $reps)';
}
