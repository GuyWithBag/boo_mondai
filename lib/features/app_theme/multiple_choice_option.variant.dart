import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ButtonVariant, ButtonColor, TextColor;
import 'package:theme_variants/theme_variants.dart';

enum MultipleChoiceOptionState { idle, hovered, selected, faded, disabled }

enum MultipleChoiceOptionTone { neutral, success, error }

class MultipleChoiceOptionStyle {
  const MultipleChoiceOptionStyle({
    this.buttonVariants,
    this.selected,
    this.opacity,
    this.textTone,
  });

  final List<Object>? buttonVariants;
  final bool? selected;
  final double? opacity;
  final TextColor? textTone;

  MultipleChoiceOptionStyle merge(MultipleChoiceOptionStyle other) {
    return MultipleChoiceOptionStyle(
      buttonVariants: other.buttonVariants ?? buttonVariants,
      selected: other.selected ?? selected,
      opacity: other.opacity ?? opacity,
      textTone: other.textTone ?? textTone,
    );
  }
}

final multipleChoiceOptionStyle =
    VariantStyle<AppTokens, MultipleChoiceOptionStyle>(
      base: (_) => const MultipleChoiceOptionStyle(
        buttonVariants: [ButtonVariant.ghost, ButtonColor.neutral],
        selected: false,
        opacity: 1,
      ),
      merge: (base, variant) => base.merge(variant),
      defaultVariants: const [
        MultipleChoiceOptionState.idle,
        MultipleChoiceOptionTone.neutral,
      ],
      variants: {
        MultipleChoiceOptionState.idle: (_) =>
            const MultipleChoiceOptionStyle(),
        MultipleChoiceOptionState.hovered: (_) =>
            const MultipleChoiceOptionStyle(
              selected: true,
              textTone: TextColor.brand,
            ),
        MultipleChoiceOptionState.selected: (_) =>
            const MultipleChoiceOptionStyle(
              selected: true,
              textTone: TextColor.brand,
            ),
        MultipleChoiceOptionState.faded: (_) =>
            const MultipleChoiceOptionStyle(opacity: 0.5),
        MultipleChoiceOptionState.disabled: (_) =>
            const MultipleChoiceOptionStyle(opacity: 0.5),
        MultipleChoiceOptionTone.neutral: (_) =>
            const MultipleChoiceOptionStyle(
              buttonVariants: [ButtonVariant.ghost, ButtonColor.neutral],
            ),
        MultipleChoiceOptionTone.success: (_) =>
            const MultipleChoiceOptionStyle(
              buttonVariants: [ButtonVariant.soft, ButtonColor.success],
            ),
        MultipleChoiceOptionTone.error: (_) => const MultipleChoiceOptionStyle(
          buttonVariants: [ButtonVariant.soft, ButtonColor.error],
        ),
      },
    );
