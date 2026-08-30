import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

abstract class MarkdownAlignmentHelper {
  static MarkdownStyleSheet alignStyleSheet(
    MarkdownStyleSheet styleSheet,
    String? marker,
  ) {
    return copyStyleSheetWithAlignment(
      styleSheet,
      wrapAlignmentForMarker(marker),
    );
  }

  static WrapAlignment wrapAlignmentForMarker(String? marker) {
    return switch (marker) {
      '=' => WrapAlignment.center,
      '>' => WrapAlignment.end,
      _ => WrapAlignment.start,
    };
  }

  static Alignment alignmentForWrapAlignment(WrapAlignment alignment) {
    return switch (alignment) {
      WrapAlignment.center => Alignment.center,
      WrapAlignment.end => Alignment.centerRight,
      _ => Alignment.centerLeft,
    };
  }

  static MarkdownStyleSheet copyStyleSheetWithAlignment(
    MarkdownStyleSheet styleSheet,
    WrapAlignment alignment,
  ) {
    return styleSheet.copyWith(
      textAlign: alignment,
      h1Align: alignment,
      h2Align: alignment,
      h3Align: alignment,
      h4Align: alignment,
      h5Align: alignment,
      h6Align: alignment,
      unorderedListAlign: alignment,
      orderedListAlign: alignment,
      blockquoteAlign: alignment,
      codeblockAlign: alignment,
    );
  }
}
