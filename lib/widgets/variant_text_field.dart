import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../variant_styles/variant_styles.barrel.dart';

class VariantTextField extends StatelessWidget {
  const VariantTextField({
    required this.variants,
    this.controller,
    this.enabled,
    this.onChanged,
    this.placeholder,
    this.maxLines = 1,
    this.expands = false,
    this.textAlignVertical,
    super.key,
  });

  final Iterable<Object> variants;
  final TextEditingController? controller;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final style = appTextFieldStyle.resolve(tokens, variants);

    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      textAlign: style.textAlign ?? TextAlign.start,
      cursorColor: style.cursorColor,
      maxLines: maxLines,
      expands: expands,
      textAlignVertical: textAlignVertical,
      style: style.textStyle,
      decoration: InputDecoration(
        hintText: placeholder,
      ).applyDefaults(style.decorationTheme),
    );
  }
}
