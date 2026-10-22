abstract class StudySessionStep {
  final String id;
  final String? insertedByRuleId;
  final String? insertionReason;

  const StudySessionStep({
    required this.id,
    this.insertedByRuleId,
    this.insertionReason,
  });
}
