import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChangeType,
        Deck,
        DeckTile,
        DeckTileState,
        surfaceStyle,
        ThemeController;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class NewDeckBlock extends StatelessWidget {
  const NewDeckBlock({super.key, required this.type});

  final ChangeType type;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
    final icon = switch (type) {
      ChangeType.added => Icons.add,
      ChangeType.removed => Icons.remove,
      _ => throw UnimplementedError(),
    };
    final action = switch (type) {
      ChangeType.added => 'Deck Added',
      ChangeType.removed => 'Deck Removed',
      _ => throw UnimplementedError(),
    };

    return Surface(
      style: surfaceStyle.resolve(tokens),
      child: Column(
        children: [
          Surface(child: Row(children: [Icon(icon), Text(action)])),
          DeckTile(deck: Deck.createDummy(), state: DeckTileState.spread),
          Text('Deck Title'),
        ],
      ),
    );
  }
}
