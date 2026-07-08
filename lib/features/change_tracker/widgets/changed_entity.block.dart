import 'package:boo_mondai/core/theme/app_tokens.model.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeTrackerHelper,
        ChangedEntity,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart'
    show Surface, ThemeVariantsContext;

class ChangedEntityBlock extends StatelessWidget {
  const ChangedEntityBlock({
    super.key,
    required this.changedEntity,
    this.child,
    this.name,
  });

  final ChangedEntity changedEntity;
  final Widget? child;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final headerStyle = surfaceStyle.resolve(tokens, const [
      SurfaceColor.muted,
      SurfaceBorder.none,
      SurfaceShadow.none,
      SurfaceShape.sharp,
    ]);
    return Surface(
      style: surfaceStyle
          .resolve(tokens, const [
            SurfacePadding.none,
            SurfaceBorder.none,
            SurfaceShape.roundedSm,
            SurfaceShadow.none,
          ])
          .copyWith(clipBehavior: Clip.hardEdge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Surface(
            style: headerStyle,
            child: Row(
              spacing: tokens.spaceLayoutGapSm,
              children: [
                Icon(ChangeTrackerHelper.getTypeIcon(changedEntity.changeType)),
                Text(
                  '${changedEntity.typeName} ${ChangeTrackerHelper.getTypeLabel(changedEntity.changeType)}',
                  style: textStyle.resolve(tokens, const [
                    TextSize.label,
                    TextWeight.body,
                  ]),
                ),
              ],
            ),
          ),
          Padding(padding: headerStyle.padding!, child: child),
          Padding(
            padding: headerStyle.padding!,
            child: Text(
              name != null ? name! : changedEntity.typeName,
              textAlign: TextAlign.start,
              style: textStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.body,
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
