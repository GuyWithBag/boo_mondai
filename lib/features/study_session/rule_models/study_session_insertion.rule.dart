import 'package:boo_mondai/lib.barrel.dart'
    show StudySessionRuleContext, SessionFlowCommand;

abstract interface class StudySessionInsertionRule {
  String get id;

  List<SessionFlowCommand> evaluate(StudySessionRuleContext context);
}
