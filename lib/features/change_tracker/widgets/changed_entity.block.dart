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
    this.directionLabel,
  });

  final ChangedEntity changedEntity;
  final Widget? child;
  final String? name;
  final String? directionLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final headerStyle = surfaceStyle.resolve(tokens, const [
      SurfaceColor.muted,
      SurfaceBorder.none,
      SurfaceShadow.none,
      SurfaceShape.sharp,
    ]);
    final coloredHeaderDecoration = headerStyle.decoration.copyWith(
      color: ChangeTrackerHelper.getTypeBorder(
        tokens,
        changedEntity.changeType,
      ),
    );
    final coloredHeaderStyle = headerStyle.copyWith(
      decoration: coloredHeaderDecoration,
    );
    final containerStyle = surfaceStyle.resolve(tokens, const [
      SurfacePadding.none,
      SurfaceBorder.none,
      SurfaceShape.roundedSm,
      SurfaceShadow.none,
    ]);
    final coloredContainerDecoration = containerStyle.decoration.copyWith(
      color: ChangeTrackerHelper.getTypeBackground(
        tokens,
        changedEntity.changeType,
      ),
    );
    final coloredContainerStyle = containerStyle.copyWith(
      decoration: coloredContainerDecoration,
    );
    return Surface(
      style: coloredContainerStyle,
      hasClipRRect: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Surface(
            style: coloredHeaderStyle,
            child: Row(
              spacing: tokens.spaceLayoutGapSm,
              children: [
                Icon(
                  ChangeTrackerHelper.getTypeIcon(changedEntity.changeType),
                  color: ChangeTrackerHelper.getTypeForeground(
                    tokens,
                    changedEntity.changeType,
                  ),
                ),
                Text(
                  [
                    if (directionLabel != null) directionLabel,
                    changedEntity.typeName,
                    ChangeTrackerHelper.getTypeLabel(changedEntity.changeType),
                  ].join(' '),
                  style: textStyle
                      .resolve(tokens, const [TextSize.label, TextWeight.body])
                      .copyWith(
                        color: ChangeTrackerHelper.getTypeForeground(
                          tokens,
                          changedEntity.changeType,
                        ),
                      ),
                ),
              ],
            ),
          ),
          if (child != null)
            Padding(padding: coloredHeaderStyle.padding!, child: child),
          if (child != null)
            Padding(
              padding: EdgeInsets.only(
                left: tokens.spaceLayoutPadding,
                right: tokens.spaceLayoutPadding,
                bottom: tokens.spaceLayoutPadding,
              ),
              child: Text(
                name != null ? name! : changedEntity.typeName,
                textAlign: TextAlign.start,
                style: textStyle
                    .resolve(tokens, const [TextSize.header, TextWeight.body])
                    .copyWith(
                      color: ChangeTrackerHelper.getTypeForeground(
                        tokens,
                        changedEntity.changeType,
                      ),
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
