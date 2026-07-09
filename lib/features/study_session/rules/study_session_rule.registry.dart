import 'package:boo_mondai/features/study_session/engine/session_flow.command.dart';
import 'package:boo_mondai/features/study_session/rules/study_session_insertion.rule.dart';
import 'package:boo_mondai/features/study_session/rules/study_session_rule.context.dart';

final class StudySessionRuleRegistry {
  const StudySessionRuleRegistry(this.rules);

  final List<StudySessionInsertionRule> rules;

  List<SessionFlowCommand> evaluate(StudySessionRuleContext context) {
    return [for (final rule in rules) ...rule.evaluate(context)];
  }
}
