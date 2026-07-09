import 'package:boo_mondai/features/study_session/engine/session_flow.command.dart';
import 'package:boo_mondai/features/study_session/rules/study_session_rule.context.dart';

abstract interface class StudySessionInsertionRule {
  String get id;

  List<SessionFlowCommand> evaluate(StudySessionRuleContext context);
}
