import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownText,
        MarkdownTextMode,
        TextFieldSize,
        TextFieldFrame,
        TextFieldTone;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MatchingTypeInput extends HookWidget {
  const MatchingTypeInput({required this.value, this.onChanged, super.key});

  final String value;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: value);
    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
      }
      return null;
    }, [value]);

    return MarkdownText(
      data: value,
      controller: controller,
      onChanged: onChanged,
      mode: MarkdownTextMode.input,
      variants: const [
        TextFieldSize.labelLarge,
        TextFieldFrame.outline,
        TextFieldTone.neutral,
      ],
    );
  }
}
