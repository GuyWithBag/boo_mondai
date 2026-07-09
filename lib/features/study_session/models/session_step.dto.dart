import 'package:dart_mappable/dart_mappable.dart';

part 'session_step.dto.mapper.dart';

@MappableClass(
  discriminatorKey: 'step_type',
  includeSubClasses: [CardSessionStep, MessageSessionStep, SummarySessionStep],
)
abstract class SessionStep with SessionStepMappable {
  final String id;
  final String? insertedByRuleId;
  final String? insertionReason;

  const SessionStep({
    required this.id,
    this.insertedByRuleId,
    this.insertionReason,
  });

  bool get producesRecord;
}

@MappableClass(discriminatorValue: 'card')
final class CardSessionStep extends SessionStep with CardSessionStepMappable {
  final String studyCardId;
  final int attemptNumber;

  const CardSessionStep({
    required super.id,
    required this.studyCardId,
    this.attemptNumber = 1,
    super.insertedByRuleId,
    super.insertionReason,
  });

  @override
  bool get producesRecord => true;
}

@MappableClass(discriminatorValue: 'message')
final class MessageSessionStep extends SessionStep
    with MessageSessionStepMappable {
  final String messageDefinitionId;
  final String title;
  final String message;

  const MessageSessionStep({
    required super.id,
    required this.messageDefinitionId,
    required this.title,
    required this.message,
    super.insertedByRuleId,
    super.insertionReason,
  });

  @override
  bool get producesRecord => false;
}

@MappableClass(discriminatorValue: 'summary')
final class SummarySessionStep extends SessionStep
    with SummarySessionStepMappable {
  const SummarySessionStep({
    required super.id,
    super.insertedByRuleId,
    super.insertionReason,
  });

  @override
  bool get producesRecord => false;
}
