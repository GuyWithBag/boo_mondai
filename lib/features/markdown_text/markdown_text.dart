import 'package:boo_mondai/features/markdown_text/markdown_text.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownAttachmentUrlResolver,
        TextColor,
        TextFieldFrame,
        TextFieldSize,
        TextSize,
        TextWeight,
        textStyle;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:theme_variants/theme_variants.dart';

/// Displays or edits markdown content according to [mode].
///
/// Link taps in [MarkdownTextMode.preview] and [MarkdownTextMode.previewSelectable]
/// are handled automatically via `url_launcher`. Supply [onTapLink] to
/// intercept or override that behaviour.
class MarkdownText extends HookWidget {
  const MarkdownText({
    required this.data,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.expands = false,
    this.textAlignVertical,
    this.scrollPadding = const EdgeInsets.all(20),
    this.variants = const [TextFieldSize.normal, TextFieldFrame.outline],
    this.mode = MarkdownTextMode.raw,
    this.onTapLink,
    this.resolveAttachmentUrl,
    this.baseTextStyle,
    this.defaultMarkdownAlignment = WrapAlignment.center,
    this.contentScale = 1,
    this.useToolBar = true,
    this.allowAttachments = false,
    super.key,
    this.placeholderTextStyle,
  });

  final String data;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle? baseTextStyle;
  final TextStyle? placeholderTextStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets scrollPadding;
  final Iterable<Object> variants;
  final MarkdownTextMode mode;
  final WrapAlignment defaultMarkdownAlignment;
  final double contentScale;
  final bool useToolBar;
  final bool allowAttachments;

  /// Called when a link is tapped in preview modes. When null, links are
  /// opened via [url_launcher] automatically.
  final MarkdownTapLinkCallback? onTapLink;

  /// Resolves markdown media URIs like `local:<id>` to displayable URLs. Used
  /// for images and by the default link launcher.
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedTextStyle =
        baseTextStyle ??
        textStyle.resolve(tokens, const [
          TextSize.label,
          TextWeight.body,
          TextColor.baseline,
        ]);
    final resolvedPlaceholderTextStyle =
        placeholderTextStyle ??
        textStyle.resolve(tokens, const [
          TextSize.label,
          TextWeight.body,
          TextColor.muted,
        ]);
    return switch (mode) {
      MarkdownTextMode.previewSelectable => MarkdownTextPreviewSelectable(
        resolvedTextStyle: resolvedTextStyle,
        data: data,
        selectable: true,
        defaultAlignment: defaultMarkdownAlignment,
        contentScale: contentScale,
      ),
      MarkdownTextMode.preview => MarkdownTextPreview(
        resolvedTextStyle: resolvedTextStyle,
        data: data,
        selectable: false,
        defaultAlignment: defaultMarkdownAlignment,
        contentScale: contentScale,
      ),
      MarkdownTextMode.raw => Text(
        data,
        style: resolvedTextStyle,
        maxLines: maxLines,
      ),
      MarkdownTextMode.input => MarkdownTextInput(
        data: data,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        placeholderTextStyle: resolvedPlaceholderTextStyle,
        resolvedTextStyle: resolvedTextStyle,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
        scrollPadding: scrollPadding,
        variants: variants,
        useToolBar: useToolBar,
        allowAttachments: allowAttachments,
      ),
      MarkdownTextMode.inputPreview => MarkdownTextInputPreview(
        data: data,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        resolvedTextStyle: resolvedTextStyle,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
        scrollPadding: scrollPadding,
        variants: variants,
        onTapLink: onTapLink,
        resolveAttachmentUrl: resolveAttachmentUrl,
        defaultMarkdownAlignment: defaultMarkdownAlignment,
        contentScale: contentScale,
        useToolBar: useToolBar,
        allowAttachments: allowAttachments,
      ),
    };
  }
}
