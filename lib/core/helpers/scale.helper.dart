import 'package:flutter/material.dart';

/// Utility methods for proportional UI scaling.
///
/// Use this when a widget has a canonical/base size, but may render at a
/// different size and needs related values such as text, radii, spacing, or
/// offsets to keep the same visual proportions.
abstract final class ScaleHelper {
  /// Returns a size for a fixed aspect ratio when width is known.
  static Size getSizeFromWidthAndAspectRatio({
    required double width,
    required double aspectRatio,
  }) {
    if (aspectRatio == 0) {
      return Size(width, 0);
    }

    return Size(width, width / aspectRatio);
  }

  /// Returns the scale ratio between a current size and its base size.
  ///
  /// For example, a `current` width of `150` against a `base` width of `300`
  /// returns `0.5`. The result is clamped to `min` and `max` so very small or
  /// very large render sizes do not produce unusable UI values.
  static double getClampedSizeRatio({
    required double current,
    required double base,
    double min = 0.0,
    double max = double.infinity,
  }) {
    if (base == 0) return 1;

    return (current / base).clamp(min, max).toDouble();
  }

  /// Scales a radius from a base-size component to its current rendered size.
  ///
  /// For example, a card rendered at half its base width gets half its base
  /// radius unless constrained by `minScale` or `maxScale`.
  static double getScaledRadiusFromBase({
    required double radius,
    required double current,
    required double base,
    double minScale = 0.0,
    double maxScale = double.infinity,
  }) {
    return radius *
        getClampedSizeRatio(
          current: current,
          base: base,
          min: minScale,
          max: maxScale,
        );
  }

  /// Returns a copy of [style] with its `fontSize` multiplied by [scale].
  ///
  /// If [style] has no explicit `fontSize`, it is returned unchanged because
  /// there is no concrete value to scale.
  static TextStyle getTextStyleWithScaledFontSize(
    TextStyle style,
    double scale,
  ) {
    final fontSize = style.fontSize;

    if (fontSize == null) {
      return style;
    }

    return style.copyWith(fontSize: fontSize * scale);
  }
}
