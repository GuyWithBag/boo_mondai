import 'package:boo_mondai/lib.barrel.dart' show MarkdownTextBody;
import 'package:flutter/material.dart';

class MarkdownTextPreview extends StatelessWidget {
  const MarkdownTextPreview({
    super.key,
    required this.resolvedTextStyle,
    required this.data,
    required this.selectable,
    required this.defaultAlignment,
    this.contentScale = 1,
  });

  final TextStyle resolvedTextStyle;
  final String data;
  final bool selectable;
  final WrapAlignment defaultAlignment;
  final double contentScale;
  @override
  Widget build(BuildContext context) {
    return MarkdownTextBody(
      resolvedTextStyle: resolvedTextStyle,
      data: data,
      selectable: false,
      defaultAlignment: defaultAlignment,
      contentScale: contentScale,
    );
  }
}
