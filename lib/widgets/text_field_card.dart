import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/shared.barrel.dart';

import 'tactile_button.dart';
import 'variant_text_field.dart';

class TextFieldCard extends StatelessWidget {
  const TextFieldCard({
    required this.title,
    required this.placeholder,
    this.controller,
    this.onChanged,
    this.minHeight,
    super.key,
  });

  final String title;
  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedSurfaceStyle = surfaceStyle.resolve(tokens);

    return SizedBox(
      height: minHeight ?? 260,
      child: Surface(
        style: resolvedSurfaceStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: appTextStyle.resolve(tokens, [
                TextSize.labelSmall,
                TextWeight.heavy,
                TextTone.muted,
              ]),
            ),
            SizedBox(height: tokens.spacePanelGapLg),
            Expanded(
              child: VariantTextField(
                controller: controller,
                onChanged: onChanged,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                placeholder: placeholder,
                variants: const [
                  AppTextFieldSize.bodyLarge,
                  AppTextFieldFrame.none,
                  AppTextFieldTone.neutral,
                ],
              ),
            ),
            Column(
              children: [
                Divider(),
                SizedBox(height: tokens.spacePanelGapMd),
              ],
            ),
            Row(
              children: [
                TactileButton.icon(
                  onPressed: () {},
                  icon: Icons.image_outlined,
                ),
                SizedBox(width: tokens.spacePanelGapSm),
                TactileButton.icon(onPressed: () {}, icon: Icons.mic),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
