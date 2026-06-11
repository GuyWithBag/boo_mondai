import 'package:boo_mondai/lib.barrel.dart' show AppTokens, appTextFieldStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class VariantTextField extends StatelessWidget {
  const VariantTextField({
    required this.variants,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.textStyle,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.expands = false,
    this.textAlignVertical,
    super.key,
  });

  final Iterable<Object> variants;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final style = appTextFieldStyle.resolve(tokens, variants);

    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      textAlign: style.textAlign ?? TextAlign.start,
      cursorColor: style.cursorColor,
      maxLines: maxLines,
      expands: expands,
      textAlignVertical: textAlignVertical,
      style: textStyle ?? style.textStyle,
      decoration: InputDecoration(
        hintText: placeholder,
      ).applyDefaults(style.decorationTheme),
    );
  }
}
