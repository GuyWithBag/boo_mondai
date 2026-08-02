import 'package:boo_mondai/features/study_session/session_steps/session_step.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'message.session_step.mapper.dart';

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
