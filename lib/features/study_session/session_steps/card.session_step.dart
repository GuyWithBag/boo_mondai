import 'package:boo_mondai/features/study_session/session_steps/session_step.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'card.session_step.mapper.dart';

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
