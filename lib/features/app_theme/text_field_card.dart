import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownText,
        MarkdownTextMode,
        SectionEyebrow,
        SurfaceShape,
        TextFieldFrame,
        TextFieldSize,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class TextFieldCard extends HookWidget {
  const TextFieldCard({
    required this.title,
    required this.placeholder,
    this.hasAttachments = true,
    this.controller,
    this.onChanged,
    this.onFocused,
    this.minHeight,
    super.key,
  });

  final String title;
  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<TextEditingController>? onFocused;
  final double? minHeight;
  final bool hasAttachments;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final focusNode = useFocusNode();
    final resolvedSurfaceStyle = surfaceStyle.resolve(tokens, const [
      SurfaceShape.roundedSm,
    ]);

    useEffect(() {
      void listener() {
        final controller = this.controller;
        if (focusNode.hasFocus && controller != null) {
          onFocused?.call(controller);
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode, controller, onFocused]);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight ?? 260),
      child: Surface(
        style: resolvedSurfaceStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionEyebrow(title.toUpperCase()),
            SizedBox(height: tokens.spaceLayoutGapMd),
            MarkdownText(
              data: controller?.text ?? '',
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              maxLines: null,
              expands: false,
              textAlignVertical: TextAlignVertical.top,
              placeholder: placeholder,
              mode: MarkdownTextMode.input,
              variants: const [TextFieldSize.bodyLarge, TextFieldFrame.none],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
