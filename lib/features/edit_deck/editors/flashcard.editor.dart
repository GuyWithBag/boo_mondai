import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateFormState,
        EditDeckFormValidator,
        FormField,
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
import 'package:flutter/material.dart' hide FormField;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                spacing: tokens.spaceLayoutGapMd,

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Type',
                    style: textStyle.resolve(tokens, [
                      TextSize.labelLarge,
                      TextWeight.heavy,
                    ]),
                  ),
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
        FormField<String>(
          value: editor.frontController.text,
          listenable: editor.frontController,
          valueReader: () => editor.frontController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Front (Prompt)',
            placeholder: 'Type a word...',
            controller: editor.frontController,
            onChanged: field.didChange,
          ),
        ),
        FormField<String>(
          value: editor.backController.text,
          listenable: editor.backController,
          valueReader: () => editor.backController.text,
          validator: EditDeckFormValidator.answer,
          builder: (_, field) => TextFieldCard(
            title: 'Back (Answer)',
            placeholder: 'Type the translation...',
            controller: editor.backController,
            onChanged: field.didChange,
          ),
        ),
      ],
    );
  }
}
