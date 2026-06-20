import 'package:boo_mondai/lib.barrel.dart' show EditDeckController;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

EditDeckController useEditDeckController({
  required String deckId,
  String? initialTemplateId,
}) {
  final controller = useMemoized(
    () => EditDeckController(
      deckId: deckId,
      initialTemplateId: initialTemplateId,
    ),
    [deckId, initialTemplateId],
  );

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
