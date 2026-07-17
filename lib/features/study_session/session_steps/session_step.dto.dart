import 'package:boo_mondai/features/study_session/session_steps/card.session_step.dart';
import 'package:boo_mondai/features/study_session/session_steps/message.session_step.dart';
import 'package:boo_mondai/features/study_session/session_steps/summary.session_step.dart';
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
