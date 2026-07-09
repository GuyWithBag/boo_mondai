import 'package:boo_mondai/features/study_session/engine/session_flow.command.dart';
import 'package:boo_mondai/features/study_session/models/session_step.dto.dart';
import 'package:boo_mondai/features/study_session/rules/study_session_insertion.rule.dart';
import 'package:boo_mondai/features/study_session/rules/study_session_rule.context.dart';

typedef StudySessionRuleCondition =
    bool Function(StudySessionRuleContext context);
typedef StudySessionRuleOccurrenceKey =
    String Function(StudySessionRuleContext context);
typedef StudySessionMessageBuilder =
    MessageSessionStep Function(StudySessionRuleContext context);

final class ConditionalMessageRule implements StudySessionInsertionRule {
  const ConditionalMessageRule({
    required this.id,
    required StudySessionRuleCondition when,
    required StudySessionRuleOccurrenceKey occurrenceKey,
    required StudySessionMessageBuilder buildMessage,
  }) : _when = when,
       _occurrenceKey = occurrenceKey,
       _buildMessage = buildMessage;

  @override
  final String id;
  final StudySessionRuleCondition _when;
  final StudySessionRuleOccurrenceKey _occurrenceKey;
  final StudySessionMessageBuilder _buildMessage;

  @override
  List<SessionFlowCommand> evaluate(StudySessionRuleContext context) {
    if (!_when(context)) return const [];

    final occurrenceKey = '$id:${_occurrenceKey(context)}';
    if (context.firedRuleKeys.contains(occurrenceKey)) return const [];

    return [
      InsertAfterCurrent(
        occurrenceKey: occurrenceKey,
        step: _buildMessage(context),
      ),
    ];
  }
}
