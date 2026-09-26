
import 'package:boo_mondai/lib.barrel.dart' show uuid, StudySessionRule, StudyRating, StudySessionMessageStep;

abstract final class StudySessionRules {
  static final rules = <StudySessionRule>[
    StudySessionRule(
      id: 'three-incorrect-v1',
      when: (session) {
        final ratings = session.history
            .map((entry) => entry.rating)
            .whereType<StudyRating>();
        return ratings
                .toList()
                .reversed
                .takeWhile(
                  (rating) =>
                      rating == StudyRating.incorrect ||
                      rating == StudyRating.again,
                )
                .length ==
            3;
      },
      build: (session) => StudySessionMessageStep(
        id: uuid.v7(),
        messageDefinitionId: 'slow-down',
        title: 'Take your time',
        message:
            'Read each prompt carefully. Accuracy matters more than speed.',
        insertedByRuleId: 'three-incorrect-v1',
        insertionReason: 'Three consecutive incorrect answers',
      ),
    ),
    StudySessionRule(
      id: 'progress-encouragement-v1',
      when: (session) => const {5, 10, 20}.contains(
        session.history.where((entry) => entry.rating != null).length,
      ),
      build: (session) {
        final count = session.history
            .where((entry) => entry.rating != null)
            .length;
        return StudySessionMessageStep(
          id: uuid.v7(),
          messageDefinitionId: 'progress-milestone',
          title: 'Good progress',
          message: '$count cards completed.',
          insertedByRuleId: 'progress-encouragement-v1',
          insertionReason: 'Completed $count card steps',
        );
      },
    ),
  ];
}
