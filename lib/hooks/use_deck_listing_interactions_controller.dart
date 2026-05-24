import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

DeckListingInteractionsController useDeckListingInteractionsController(
  Deck deck, {
  bool enabled = true,
}) {
  final controller = useMemoized(
    () => DeckListingInteractionsController(deck: deck),
    [deck.id],
  );

  useListenable(controller);

  useEffect(() {
    if (enabled) {
      controller.loadInteractionState();
    }
    return controller.dispose;
  }, [controller, enabled]);

  return controller;
}
