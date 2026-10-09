import 'package:boo_mondai/lib.barrel.dart' show ScaleHelper;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

SurfaceStyle scaledSurfaceStyle(SurfaceStyle style, double scale) {
  final padding = style.padding;

  return style.copyWith(
    padding: padding is EdgeInsets
        ? ScaleHelper.getScaledEdgeInsets(padding, scale)
        : padding,
    width: style.width == null
        ? null
        : ScaleHelper.getScaledValue(style.width!, scale),
    height: style.height == null
        ? null
        : ScaleHelper.getScaledValue(style.height!, scale),
  );
}
