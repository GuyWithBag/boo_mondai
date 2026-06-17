import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceOptionState,
        MultipleChoiceOptionTone,
        AppTokens,
        multipleChoiceOptionStyle,
        ButtonTone,
        TextTone,
        textStyle,
        TextSize,
        TextWeight,
        ButtonDepth,
        TactileRadioCircle,
        Button;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class EditMultipleChoiceOption extends HookWidget {
  const EditMultipleChoiceOption({
    required this.value,
    this.correct = false,
    this.state = MultipleChoiceOptionState.idle,
    this.tone = MultipleChoiceOptionTone.neutral,
    this.isEditable = true,
    this.showRadio = false,
    this.onPressed,
    this.onTextChanged,
    this.onCorrectChanged,
    this.onRemove,
    this.canRemove = true,
    super.key,
  });

  final String value;
  final bool correct;
  final MultipleChoiceOptionState state;
  final MultipleChoiceOptionTone tone;
  final bool isEditable;
  final bool showRadio;
  final VoidCallback? onPressed;
  final ValueChanged<String>? onTextChanged;
  final VoidCallback? onCorrectChanged;
  final VoidCallback? onRemove;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useTextEditingController(text: value);
    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
      }
      return null;
    }, [value]);
    final hovered = useState(false);
    final effectiveState =
        state == MultipleChoiceOptionState.idle &&
            hovered.value &&
            onPressed != null
        ? MultipleChoiceOptionState.hovered
        : state;
    final resolvedStyle = multipleChoiceOptionStyle.resolve(tokens, [
      effectiveState,
      tone,
    ]);
    final effectiveTone =
        resolvedStyle.buttonTone ??
        (correct ? ButtonTone.success : ButtonTone.ghost);
    final effectiveSelected = resolvedStyle.selected ?? false;
    final effectiveOpacity = resolvedStyle.opacity ?? 1;
    final effectiveTextTone = resolvedStyle.textTone ?? TextTone.baseline;
    final effectiveOnPressed =
        onPressed ?? onCorrectChanged ?? (!isEditable ? () {} : null);
    final optionText = isEditable
        ? TextField(
            controller: controller,
            onChanged: onTextChanged,
            style: TextStyle(
              color: tokens.colorTextBaseline,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            decoration: const InputDecoration.collapsed(hintText: ''),
          )
        : Text(
            value,
            style: textStyle.resolve(tokens, [
              TextSize.labelLarge,
              TextWeight.heavy,
              effectiveTextTone,
            ]),
          );

    return MouseRegion(
      onEnter: (_) => hovered.value = true,
      onExit: (_) => hovered.value = false,
      child: IgnorePointer(
        ignoring: onPressed == null && !isEditable,
        child: Opacity(
          opacity: effectiveOpacity,
          child: Button(
            variants: [ButtonDepth.flat, effectiveTone],
            selected: effectiveSelected,
            mainAxisAlignment: MainAxisAlignment.start,
            onPressed: effectiveOnPressed,
            leading: showRadio ? TactileRadioCircle(correct: correct) : null,
            trailing: isEditable
                ? IconButton(
                    color: tokens.colorTextMuted,
                    onPressed: canRemove ? onRemove : null,
                    icon: const Icon(Icons.delete),
                  )
                : null,
            child: optionText,
          ),
        ),
      ),
    );
  }
}
