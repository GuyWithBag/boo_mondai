import 'package:boo_mondai/lib.barrel.dart' show StudySessionMessageStep, StudySession;


final class StudySessionRule {
  const StudySessionRule({
    required this.id,
    required this.when,
    required this.build,
  });

  final String id;
  final bool Function(StudySession session) when;
  final StudySessionMessageStep Function(StudySession session) build;
}