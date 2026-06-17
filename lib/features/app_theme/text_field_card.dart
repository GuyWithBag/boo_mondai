import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        TextSize,
        surfaceStyle,
        textStyle,
        TextWeight,
        TextTone,
        TextFieldSize,
        TextFieldFrame,
        TextFieldTone,
        Button,
        VariantTextField;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

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
              style: textStyle.resolve(tokens, [
                TextSize.labelSmall,
                TextWeight.heavy,
                TextTone.muted,
              ]),
            ),
            SizedBox(height: tokens.spaceLayoutGapLg),
            Expanded(
              child: VariantTextField(
                controller: controller,
                onChanged: onChanged,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                placeholder: placeholder,
                variants: const [
                  TextFieldSize.bodyLarge,
                  TextFieldFrame.none,
                  TextFieldTone.neutral,
                ],
              ),
            ),
            Column(
              children: [
                Divider(),
                SizedBox(height: tokens.spaceLayoutGapMd),
              ],
            ),
            Row(
              children: [
                Button.icon(onPressed: () {}, icon: Icons.image_outlined),
                SizedBox(width: tokens.spaceLayoutGapSm),
                Button.icon(onPressed: () {}, icon: Icons.mic),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
