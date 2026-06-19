import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        TextColor,
        TextFieldFrame,
        TextFieldSize,
        TextFieldTone,
        TextSize,
        TextWeight,
        VariantTextField,
        textStyle,
        MarkdownHelper;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:theme_variants/theme_variants.dart';

enum MarkdownTextMode { input, raw, preview }

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
    this.variants = const [
      TextFieldSize.normal,
      TextFieldFrame.outline,
      TextFieldTone.neutral,
    ],
    this.mode = MarkdownTextMode.raw,
    this.selectable = true,
    this.onTapLink,
    this.baseTextStyle,
    super.key,
  });

  final String data;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle? baseTextStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final Iterable<Object> variants;
  final MarkdownTextMode mode;
  final bool selectable;
  final MarkdownTapLinkCallback? onTapLink;

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

    if (mode == MarkdownTextMode.input) {
      final internalController = useTextEditingController(text: data);
      final effectiveController = controller ?? internalController;

      useEffect(() {
        if (effectiveController.text != data) {
          effectiveController.text = data;
        }
        return null;
      }, [data, effectiveController]);

      return VariantTextField(
        variants: variants,
        controller: effectiveController,
        focusNode: focusNode,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        textStyle: resolvedTextStyle,
        keyboardType: keyboardType ?? TextInputType.multiline,
        textInputAction: textInputAction ?? TextInputAction.newline,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
      );
    }

    return switch (mode) {
      MarkdownTextMode.raw => SelectableText(
        data,
        style: resolvedTextStyle,
        maxLines: maxLines,
      ),
      MarkdownTextMode.preview => MarkdownBody(
        data: data,
        selectable: selectable,
        onTapLink: onTapLink,
        styleSheet: MarkdownHelper.getMarkdownStyleSheet(
          tokens,
          resolvedTextStyle,
        ),
      ),
      MarkdownTextMode.input => throw StateError('unreachable'),
    };
  }
}
