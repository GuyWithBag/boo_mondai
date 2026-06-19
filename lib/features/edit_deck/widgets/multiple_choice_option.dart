import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextColor,
        MarkdownText,
        MarkdownTextMode,
        TextFieldFrame,
        TextFieldSize,
        TextFieldTone,
        surfaceStyle,
        textStyle,
        TextSize,
        TextWeight;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

enum MultipleChoiceOptionState { idle, hovered, selected, faded, disabled }

enum MultipleChoiceOptionTone { neutral, success, error }

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
    final rowOnPressed = onPressed ?? (!isEditable ? () {} : null);
    final effectiveState =
        state == MultipleChoiceOptionState.idle &&
            hovered.value &&
            rowOnPressed != null
        ? MultipleChoiceOptionState.hovered
        : state;
    final effectiveSelected =
        effectiveState == MultipleChoiceOptionState.hovered ||
        effectiveState == MultipleChoiceOptionState.selected;
    final effectiveOpacity =
        effectiveState == MultipleChoiceOptionState.faded ||
            effectiveState == MultipleChoiceOptionState.disabled
        ? 0.5
        : 1.0;
    final effectiveTextTone = effectiveSelected
        ? TextColor.brand
        : TextColor.baseline;
    final resolvedStyle = _resolveOptionSurfaceStyle(
      tokens: tokens,
      state: effectiveState,
      tone: tone,
      correct: correct,
    );
    final optionText = isEditable
        ? MarkdownText(
            data: value,
            controller: controller,
            onChanged: onTextChanged,
            mode: MarkdownTextMode.input,
            baseTextStyle: TextStyle(
              color: tokens.colorTextBaseline,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            variants: const [
              TextFieldSize.labelLarge,
              TextFieldFrame.none,
              TextFieldTone.neutral,
            ],
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
      cursor: rowOnPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => hovered.value = true,
      onExit: (_) => hovered.value = false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: rowOnPressed,
        child: Surface(
          style: resolvedStyle.copyWith(opacity: effectiveOpacity),
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOutCubic,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (showRadio) ...[
                _RadioIndicator(correct: correct, onPressed: onCorrectChanged),
                const SizedBox(width: 10),
              ],
              Expanded(child: optionText),
              if (isEditable) ...[
                const SizedBox(width: 10),
                IconButton(
                  color: tokens.colorTextMuted,
                  onPressed: canRemove ? onRemove : null,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

SurfaceStyle _resolveOptionSurfaceStyle({
  required AppTokens tokens,
  required MultipleChoiceOptionState state,
  required MultipleChoiceOptionTone tone,
  required bool correct,
}) {
  final borderColor = switch (tone) {
    MultipleChoiceOptionTone.success => tokens.colorActionSuccessBorder,
    MultipleChoiceOptionTone.error => tokens.colorActionErrorBorder,
    MultipleChoiceOptionTone.neutral =>
      correct
          ? tokens.colorActionSuccessBorder
          : state == MultipleChoiceOptionState.hovered ||
                state == MultipleChoiceOptionState.selected
          ? tokens.colorPrimaryBright
          : tokens.colorBorderNeutralSubtle,
  };
  final backgroundColor = switch (tone) {
    MultipleChoiceOptionTone.success => tokens.colorActionSuccessBackground,
    MultipleChoiceOptionTone.error => tokens.colorActionErrorBackground,
    MultipleChoiceOptionTone.neutral =>
      correct
          ? tokens.colorActionSuccessBackground
          : state == MultipleChoiceOptionState.hovered ||
                state == MultipleChoiceOptionState.selected
          ? tokens.colorPrimarySoft
          : tokens.colorSurfaceBackground,
  };
  final shadowColor = switch (tone) {
    MultipleChoiceOptionTone.success => tokens.colorActionSuccessBorder,
    MultipleChoiceOptionTone.error => tokens.colorActionErrorBorder,
    MultipleChoiceOptionTone.neutral => borderColor.withValues(alpha: 0.30),
  };

  return surfaceStyle
      .resolve(tokens, const [
        SurfaceColor.baseline,
        SurfaceBorder.baseline,
        SurfacePadding.text,
        SurfaceShape.rounded,
        SurfaceShadow.none,
      ])
      .copyWith(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: tokens.borderWidthDefault,
          ),
          borderRadius: BorderRadius.circular(tokens.radiusSurface),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(0, tokens.buttonShadowOffset),
              blurRadius: 0,
            ),
          ],
        ),
      );
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.correct, this.onPressed});

  final bool correct;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final outerStyle = surfaceStyle
        .resolve(tokens, const [
          SurfaceShape.circle,
          SurfacePadding.none,
          SurfaceShadow.none,
        ])
        .copyWith(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: correct
                  ? tokens.colorActionSuccess
                  : tokens.colorBorderNeutralSubtle,
              width: 3,
            ),
          ),
        );

    final innerStyle = surfaceStyle
        .resolve(tokens, const [
          SurfaceShape.circle,
          SurfacePadding.none,
          SurfaceShadow.none,
        ])
        .copyWith(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: tokens.colorActionSuccess,
            shape: BoxShape.circle,
          ),
        );

    return MouseRegion(
      cursor: onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Surface(
            style: outerStyle,
            child: Center(child: correct ? Surface(style: innerStyle) : null),
          ),
        ),
      ),
    );
  }
}
