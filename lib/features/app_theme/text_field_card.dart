import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        TextSize,
        surfaceStyle,
        textStyle,
        TextWeight,
        TextColor,
        TextFieldSize,
        TextFieldFrame,
        TextFieldColor,
        MarkdownText,
        MarkdownTextMode,
        Button;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class TextFieldCard extends StatelessWidget {
  const TextFieldCard({
    required this.title,
    required this.placeholder,
    this.hasAttachments = true,
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
  final bool hasAttachments;

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
                TextColor.muted,
              ]),
            ),
            SizedBox(height: tokens.spaceLayoutGapLg),
            Expanded(
              child: MarkdownText(
                data: controller?.text ?? '',
                controller: controller,
                onChanged: onChanged,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                placeholder: placeholder,
                mode: MarkdownTextMode.input,
                variants: const [TextFieldSize.bodyLarge, TextFieldFrame.none],
              ),
            ),
            Column(
              children: [
                Divider(),
                SizedBox(height: tokens.spaceLayoutGapMd),
              ],
            ),
            if (hasAttachments)
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
