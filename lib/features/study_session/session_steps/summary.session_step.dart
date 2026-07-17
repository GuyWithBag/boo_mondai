import 'package:boo_mondai/lib.barrel.dart'
    show SummarySessionStepMappable, SessionStep;
import 'package:dart_mappable/dart_mappable.dart' show MappableClass;

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
