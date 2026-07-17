import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChangeTrackerHelper,
        ChangeType,
        ChangedProperty,
        textStyle,
        TextSize;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Renders a field-level before/after diff.
///
/// Modified values show the previous value struck through and the new value
/// below it. Added and removed records reuse the same value slots but rely on
/// the parent [ChangeType] for visual treatment.
class ChangedPropertyBlock extends StatelessWidget {
  /// Creates a diff view for [diff], styled according to [type].
  const ChangedPropertyBlock({super.key, required this.property});

  /// Field diff to render.
  final ChangedProperty property;

  @override
  Widget build(BuildContext context) {
    final type = property.type;
    if (type == ChangeType.skipped) {
      return SizedBox.shrink();
    }
    final tokens = context.themeTokens<AppTokens>();

    final propertyTextStyle = textStyle.resolve(tokens);

    final iconWidth = tokens.sizeIcon;

    final doesBeforeFitBlock = property.before.toString().length < 7;
    final doesAfterFitBlock = property.after.toString().length < 7;

    final doesPropertyFitBlock = doesBeforeFitBlock && doesAfterFitBlock;

    return Container(
      padding: EdgeInsets.all(tokens.spaceLayoutPadding),
      color: ChangeTrackerHelper.getTypeBackground(tokens, type),
      child: Column(
        spacing: tokens.spaceLayoutGapSm,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: iconWidth,
                child: IconTheme(
                  data: IconThemeData(
                    color: ChangeTrackerHelper.getTypeForeground(tokens, type),
                  ),
                  child: Icon(ChangeTrackerHelper.getTypeIcon(type)),
                ),
              ),
              Text(
                '${property.propertyLabel}: ',
                style: textStyle
                    .resolve(tokens, const [
                      // TextWeight.strong,
                      TextSize.body,
                    ])
                    .copyWith(
                      color: ChangeTrackerHelper.getTypeForeground(
                        tokens,
                        type,
                      ),
                    ),
              ),
              if (type == ChangeType.modified) ...[
                if (doesBeforeFitBlock)
                  Text(
                    '${property.before}',
                    style:
                        (type == ChangeType.modified
                                ? propertyTextStyle.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  )
                                : propertyTextStyle)
                            .copyWith(
                              color: ChangeTrackerHelper.getTypeBorder(
                                tokens,
                                type,
                              ),
                            ),
                  ),
                SizedBox(width: tokens.spaceLayoutGapSm),
                if (doesAfterFitBlock)
                  Text(
                    '${property.before}',
                    style:
                        (type == ChangeType.modified
                                ? propertyTextStyle
                                : propertyTextStyle)
                            .copyWith(
                              color: ChangeTrackerHelper.getTypeForeground(
                                tokens,
                                type,
                              ),
                            ),
                  ),
              ],
            ],
          ),
          if (type == ChangeType.modified) ...[
            if (!doesBeforeFitBlock)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: iconWidth),
                  Expanded(
                    child: Text(
                      '${property.before}',
                      style:
                          (type == ChangeType.modified
                                  ? propertyTextStyle.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    )
                                  : propertyTextStyle)
                              .copyWith(
                                color: ChangeTrackerHelper.getTypeBorder(
                                  tokens,
                                  type,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            if (!doesAfterFitBlock)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: iconWidth),
                  Expanded(
                    child: Text(
                      '${property.after}',
                      style: propertyTextStyle.copyWith(
                        color: ChangeTrackerHelper.getTypeForeground(
                          tokens,
                          type,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
