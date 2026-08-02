import 'package:boo_mondai/features/study_session/session_steps/session_step.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'summary.session_step.mapper.dart';

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
