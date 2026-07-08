import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangedEntity, ChangedPropertyBlock, surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Card that summarizes one entity-level change and its field diffs.
///
/// The card renders [ChangedEntity.title] and [ChangedEntity.subtitle] as the
/// high-level explanation, then renders [ChangedEntity.changedProperties] for
/// records that have before/after detail.
class ChangedEntitySection<T> extends StatelessWidget {
  const ChangedEntitySection({super.key, required this.entity, this.leading});

  /// Change entry to display.
  final ChangedEntity<T> entity;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    // final iconText = ChangeTrackerHelper.typePrefix(entity.type);

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            ?leading,
            Column(children: [Text(entity.entityType), Text(entity.title)]),
          ],
        ),
        Surface(
          style: surfaceStyle.resolve(tokens),
          child: Column(
            spacing: tokens.spaceLayoutGapMd,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final property in entity.changedProperties)
                ChangedPropertyBlock(property: property),
            ],
          ),
        ),
      ],
    );
  }
}
