import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateFormState,
        TextFieldCard,
        useFlashcardEditor,
        AppTokens,
        surfaceStyle,
        CardType,
        SurfaceColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        SegmentedControl,
        SegmentOption;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

class FlashcardEditor extends HookWidget {
  const FlashcardEditor({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final editor = useFlashcardEditor(formState);
    final tokens = context.themeTokens<AppTokens>();
    const options = [
      SegmentOption(value: CardType.normal, label: 'Normal'),
      SegmentOption(value: CardType.reversed, label: 'Reversed'),
      SegmentOption(value: CardType.both, label: 'Both Ways'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: tokens.spaceLayoutGapMd,
      children: [
        Surface(
          style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
          child: Column(
            spacing: tokens.spaceLayoutGapMd,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Type',
                    style: textStyle
                        .resolve(tokens, [
                          TextSize.labelLarge,
                          TextWeight.heavy,
                        ])
                        .copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    editor.directionHint,
                    style: textStyle.resolve(tokens, [
                      TextSize.label,
                      TextWeight.body,
                      TextColor.muted,
                    ]),
                  ),
                ],
              ),
              SegmentedControl<CardType>(
                options: options,
                value: editor.cardType,
                onChanged: editor.setCardType,
                isScrollable: true,
              ),
            ],
          ),
        ),
        TextFieldCard(
          title: 'Front (Prompt)',
          placeholder: 'Type a word...',
          controller: editor.frontController,
        ),
        TextFieldCard(
          title: 'Back (Answer)',
          placeholder: 'Type the translation...',
          controller: editor.backController,
        ),
      ],
    );
  }
}
