import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

StudySessionCardStageController useStudySessionCardStageController({
  required String cardId,
  required int cardIndex,
  required bool canReveal,
  String? initialAnswer,
}) {
  final controller = useMemoized(
    () => StudySessionCardStageController(
      canReveal: canReveal,
      answer: initialAnswer,
    ),
    [cardId, cardIndex],
  );

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
