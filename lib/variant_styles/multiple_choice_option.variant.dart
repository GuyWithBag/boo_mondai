import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:theme_variants/theme_variants.dart';

import 'tactile_button.variant.dart';
import 'text.variant.dart';

enum MultipleChoiceOptionState { idle, hovered, selected, faded, disabled }

enum MultipleChoiceOptionTone { neutral, success, error }

class MultipleChoiceOptionStyle {
  const MultipleChoiceOptionStyle({
    this.buttonTone,
    this.selected,
    this.opacity,
    this.textTone,
  });

  final TactileTone? buttonTone;
  final bool? selected;
  final double? opacity;
  final TextTone? textTone;

  MultipleChoiceOptionStyle merge(MultipleChoiceOptionStyle other) {
    return MultipleChoiceOptionStyle(
      buttonTone: other.buttonTone ?? buttonTone,
      selected: other.selected ?? selected,
      opacity: other.opacity ?? opacity,
      textTone: other.textTone ?? textTone,
    );
  }
}

final multipleChoiceOptionStyle =
    VariantStyle<AppTokens, MultipleChoiceOptionStyle>(
      base: (_) => const MultipleChoiceOptionStyle(
        buttonTone: TactileTone.ghost,
        selected: false,
        opacity: 1,
        textTone: TextTone.primary,
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
              textTone: TextTone.brand,
            ),
        MultipleChoiceOptionState.selected: (_) =>
            const MultipleChoiceOptionStyle(
              selected: true,
              textTone: TextTone.brand,
            ),
        MultipleChoiceOptionState.faded: (_) =>
            const MultipleChoiceOptionStyle(opacity: 0.5),
        MultipleChoiceOptionState.disabled: (_) =>
            const MultipleChoiceOptionStyle(opacity: 0.5),
        MultipleChoiceOptionTone.neutral: (_) =>
            const MultipleChoiceOptionStyle(buttonTone: TactileTone.ghost),
        MultipleChoiceOptionTone.success: (_) =>
            const MultipleChoiceOptionStyle(
              buttonTone: TactileTone.success,
              textTone: TextTone.primary,
            ),
        MultipleChoiceOptionTone.error: (_) => const MultipleChoiceOptionStyle(
          buttonTone: TactileTone.error,
          textTone: TextTone.primary,
        ),
      },
    );
