import 'package:boo_mondai/features/decks/models/deck.dto.dart' show Deck;
import 'package:boo_mondai/lib.barrel.dart'
    show DeckListingInteractionsController;
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
