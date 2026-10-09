import 'package:boo_mondai/lib.barrel.dart'
    show MarkdownAttachmentUrlResolver, MarkdownTextBody;
import 'package:flutter/material.dart';

class MarkdownTextPreviewSelectable extends StatelessWidget {
  const MarkdownTextPreviewSelectable({
    super.key,
    required this.resolvedTextStyle,
    required this.data,
    required this.selectable,
    required this.defaultAlignment,
    this.fitContent = true,
    this.contentScale = 1,
    this.resolveAttachmentUrl,
    this.imageConstraints,
    this.audioConstraints,
  });

  final TextStyle resolvedTextStyle;
  final String data;
  final bool selectable;
  final WrapAlignment defaultAlignment;
  final bool fitContent;
  final double contentScale;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final BoxConstraints? imageConstraints;
  final BoxConstraints? audioConstraints;

  @override
  Widget build(BuildContext context) {
    return MarkdownTextBody(
      resolvedTextStyle: resolvedTextStyle,
      data: data,
      selectable: false,
      defaultAlignment: defaultAlignment,
      fitContent: fitContent,
      contentScale: contentScale,
      resolveAttachmentUrl: resolveAttachmentUrl,
      imageConstraints: imageConstraints,
      audioConstraints: audioConstraints,
    );
  }
}
