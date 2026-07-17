import 'package:boo_mondai/lib.barrel.dart'
    show
        StudySessionRuleRegistry,
        ConditionalMessageRule,
        uuid,
        MessageSessionStep;

abstract class StudySessionRules {
  static StudySessionRuleRegistry getRules() {
    return StudySessionRuleRegistry([
      ConditionalMessageRule(
        id: 'three-incorrect-v1',
        when: (context) => context.consecutiveIncorrectAnswers == 3,
        occurrenceKey: (context) => 'after-step:${context.currentStepId}',
        buildMessage: (context) => MessageSessionStep(
          id: uuid.v7(),
          messageDefinitionId: 'slow-down',
          title: 'Take your time',
          message:
              'Read each prompt carefully. Accuracy matters more than speed.',
          insertedByRuleId: 'three-incorrect-v1',
          insertionReason: 'Three consecutive incorrect answers',
        ),
      ),
      ConditionalMessageRule(
        id: 'progress-encouragement-v1',
        when: (context) =>
            const {5, 10, 20}.contains(context.completedCardCount),
        occurrenceKey: (context) => 'completed:${context.completedCardCount}',
        buildMessage: (context) => MessageSessionStep(
          id: uuid.v7(),
          messageDefinitionId: 'progress-milestone',
          title: 'Good progress',
          message: '${context.completedCardCount} cards completed.',
          insertedByRuleId: 'progress-encouragement-v1',
          insertionReason: 'Completed ${context.completedCardCount} card steps',
        ),
      ),
    ]);
  }
}
