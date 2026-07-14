import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/features/app_theme/surface.variant.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChangedEntity,
        ChangedPropertyBlock,
        surfaceStyle,
        MetaLabel,
        ChangeTrackerHelper;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Card that summarizes one entity-level change and its field diffs.
///
/// The card renders [ChangedEntity.title] and [ChangedEntity.subtitle] as the
/// high-level explanation, then renders [ChangedEntity.changedProperties] for
/// records that have before/after detail.
class ChangedEntitySection<T> extends StatelessWidget {
  const ChangedEntitySection({
    super.key,
    required this.entity,
    this.leading,
    this.metaLabels = const [],
  });

  /// Change entry to display.
  final ChangedEntity<T> entity;
  final Widget? leading;
  final List<MetaLabel> metaLabels;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        Row(
          spacing: tokens.spaceLayoutGapMd,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ?leading,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...metaLabels,
                Text(
                  entity.typeName,
                  style: textStyle
                      .resolve(tokens, const [TextSize.header2])
                      .copyWith(
                        color: ChangeTrackerHelper.getTypeForeground(
                          tokens,
                          entity.changeType,
                        ),
                      ),
                ),
              ],
            ),
          ],
        ),
        if (entity.changedProperties.isNotEmpty)
          Surface(
            style: surfaceStyle.resolve(tokens, const [
              SurfaceShape.roundedXsm,
              SurfaceBorder.none,
              SurfacePadding.none,
              SurfaceShadow.none,
            ]),
            hasClipRRect: true,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, _) =>
                  SizedBox(height: tokens.spaceLayoutGapSm),
              itemCount: entity.changedProperties.length,
              itemBuilder: (_, i) =>
                  ChangedPropertyBlock(property: entity.changedProperties[i]),
            ),
          ),
      ],
    );
  }
}
