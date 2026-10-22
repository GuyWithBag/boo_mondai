import 'package:flutter/material.dart';

class MarkdownImageOptions {
  const MarkdownImageOptions({
    this.pixelWidth,
    this.pixelHeight,
    this.widthFactor,
    this.heightFactor,
    required this.fit,
    required this.alignment,
  });

  final double? pixelWidth;
  final double? pixelHeight;
  final double? widthFactor;
  final double? heightFactor;
  final BoxFit fit;
  final Alignment alignment;

  static MarkdownImageOptions parse(String? title, {String? rawOptions}) {
    final rawTitle = title?.trim();
    final raw = rawOptions?.trim();
    if (raw == null &&
        (rawTitle == null || !rawTitle.startsWith('__bm_image_options:'))) {
      return const MarkdownImageOptions(
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    }

    final options = raw ?? rawTitle!.substring('__bm_image_options:'.length);
    final params = _parseParams(options);
    final size = params['size'];
    final width = _dimension(params['w'] ?? params['width']);
    final height = _dimension(params['h'] ?? params['height']);

    return MarkdownImageOptions(
      pixelWidth: width.pixelValue ?? _sizeWidth(size),
      pixelHeight: height.pixelValue,
      widthFactor: width.factorValue ?? _sizeWidthFactor(size),
      heightFactor: height.factorValue,
      fit: _fit(params['fit']),
      alignment: _alignment(params['align']),
    );
  }

  static Map<String, String> _parseParams(String raw) {
    final params = <String, String>{};
    for (final match in RegExp(
      r'([A-Za-z][\w-]*)\s*=\s*("[^"]*"|[^\s]+)',
    ).allMatches(raw)) {
      final key = match.group(1)?.trim().toLowerCase();
      var value = match.group(2)?.trim();
      if (key == null || value == null || key.isEmpty) continue;
      if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      params[key] = value;
    }
    return params;
  }

  static _Dimension _dimension(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return const _Dimension();

    if (value.endsWith('%')) {
      final percent = double.tryParse(
        value.substring(0, value.length - 1).trim(),
      );
      if (percent == null) return const _Dimension();
      return _Dimension(factorValue: (percent / 100).clamp(0, 1));
    }

    final pixels = double.tryParse(value);
    return _Dimension(pixelValue: pixels);
  }

  static double? _sizeWidth(String? size) {
    return switch (size?.trim().toLowerCase()) {
      'xs' => 96,
      'sm' || 'small' => 160,
      'md' || 'medium' => 240,
      'lg' || 'large' => 360,
      _ => null,
    };
  }

  static double? _sizeWidthFactor(String? size) {
    return switch (size?.trim().toLowerCase()) {
      'full' => 1,
      _ => null,
    };
  }

  static BoxFit _fit(String? fit) {
    return switch (fit?.trim().toLowerCase()) {
      'cover' => BoxFit.cover,
      'fill' => BoxFit.fill,
      'fitwidth' || 'fit_width' || 'fit-width' => BoxFit.fitWidth,
      'fitheight' || 'fit_height' || 'fit-height' => BoxFit.fitHeight,
      _ => BoxFit.contain,
    };
  }

  static Alignment _alignment(String? align) {
    return switch (align?.trim().toLowerCase()) {
      'left' || 'start' => Alignment.centerLeft,
      'right' || 'end' => Alignment.centerRight,
      _ => Alignment.center,
    };
  }
}

class _Dimension {
  const _Dimension({this.pixelValue, this.factorValue});

  final double? pixelValue;
  final double? factorValue;
}
