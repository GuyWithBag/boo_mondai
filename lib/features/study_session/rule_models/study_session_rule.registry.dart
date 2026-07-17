import 'package:boo_mondai/lib.barrel.dart'
    show SessionFlowCommand, StudySessionInsertionRule, StudySessionRuleContext;

final class StudySessionRuleRegistry {
  const StudySessionRuleRegistry(this.rules);

  final List<StudySessionInsertionRule> rules;

  List<SessionFlowCommand> evaluate(StudySessionRuleContext context) {
    return [for (final rule in rules) ...rule.evaluate(context)];
  }
}
