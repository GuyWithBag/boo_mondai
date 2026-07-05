import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangedProperty, ChangeType;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

/// Renders a field-level before/after diff.
///
/// Modified values show the previous value struck through and the new value
/// below it. Added and removed records reuse the same value slots but rely on
/// the parent [ChangeType] for visual treatment.
class ChangedPropertyBlock extends StatelessWidget {
  /// Creates a diff view for [diff], styled according to [type].
  const ChangedPropertyBlock({
    super.key,
    required this.property,
    required this.type,
  });

  /// Field diff to render.
  final ChangedProperty property;

  /// Parent change type used to choose visual treatment.
  final ChangeType type;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final before = property.before;
    final after = property.after;
    final icon = switch (type) {
      ChangeType.added => Icons.add,
      ChangeType.removed => Icons.remove,
      ChangeType.modified => Icons.change_circle,
      ChangeType.skipped => Icons.skip_next,
    };

    final List<Widget> bodyBasedOnType = switch (type) {
      ChangeType.added => [Text('Front'), Divider(), Text('"asd"')],
      _ => throw UnimplementedError(),
    };

    final actionBasedOnType = switch (type) {
      ChangeType.added => Text('New Card Added'),
      ChangeType.removed => Text('Card Removed'),
      ChangeType.modified => Text('Card Modified'),
      ChangeType.skipped => Text('Card Skipped'),
    };

    return Row(
      children: [
        Icon(icon),
        Column(
          spacing: tokens.spaceLayoutGapMd,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...bodyBasedOnType],
        ),
      ],
    );
  }
}
