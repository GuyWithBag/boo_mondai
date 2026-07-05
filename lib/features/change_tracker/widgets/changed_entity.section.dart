import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangedEntity, Deck, DeckTile, surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Card that summarizes one entity-level change and its field diffs.
///
/// The card renders [ChangedEntity.title] and [ChangedEntity.subtitle] as the
/// high-level explanation, then renders [ChangedEntity.fields] for modified
/// records that have before/after detail.
class ChangedEntitySection<T> extends StatelessWidget {
  const ChangedEntitySection({super.key, required this.change});

  /// Change entry to display.
  final ChangedEntity<T> change;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    // final iconText = ChangeTrackerHelper.typePrefix(change.type);

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            DeckTile(
              deck: Deck.createNow(userId: '', title: ''),
            ),
            Column(children: [Text(change.entityType), Text(change.title)]),
          ],
        ),
        Surface(
          style: surfaceStyle.resolve(tokens),
          child: Column(spacing: tokens.spaceLayoutGapMd, children: []),
        ),
      ],
    );
  }
}
