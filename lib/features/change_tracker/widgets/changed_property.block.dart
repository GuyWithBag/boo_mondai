import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangedProperty, ChangeType, textStyle, ChangeTrackerHelper;
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

    final List<Widget> bodyBasedOnType = switch (type) {
      ChangeType.added => [
        Text('${property.propertyLabel}: ${property.after}'),
      ],
      ChangeType.removed => [
        Text('${property.propertyLabel}: ${property.before}'),
      ],
      ChangeType.modified => [
        Text(
          '${property.propertyLabel}: ${property.before}',
          style: propertyTextStyle.copyWith(
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text('${property.propertyLabel}: ${property.after}'),
      ],
      _ => throw UnimplementedError(),
    };

    return Row(
      children: [
        Icon(ChangeTrackerHelper.getTypeIcon(type)),
        Column(
          spacing: tokens.spaceLayoutGapMd,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...bodyBasedOnType,
            Text(
              '${property.propertyLabel} ${ChangeTrackerHelper.getTypeLabel(type)}',
            ),
          ],
        ),
      ],
    );
  }
}
