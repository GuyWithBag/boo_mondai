import 'package:boo_mondai/lib.barrel.dart'
    show
        CardVerticalAlignmentControl,
        EditDeckController,
        EditDeckFormValidator,
        FlashcardEditorController,
        FormField,
        TextFieldCard,
        AppTokens,
        surfaceStyle,
        CardTemplateDirection,
        SurfaceColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        SegmentedControl,
        SegmentOption;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

class FlashcardEditor extends SignalHookWidget {
  const FlashcardEditor({required this.editDeckController, super.key});

  final EditDeckController editDeckController;

  @override
  Widget build(BuildContext context) {
    final editor = useMemoized(
      () => FlashcardEditorController(editDeckController: editDeckController),
      [editDeckController.selectedTemplateKey.value],
    );
    useEffect(() => editor.dispose, [editor]);
    final tokens = context.themeTokens<AppTokens>();
    const options = [
      SegmentOption(value: CardTemplateDirection.normal, label: 'Normal'),
      SegmentOption(value: CardTemplateDirection.reversed, label: 'Reversed'),
      SegmentOption(value: CardTemplateDirection.both, label: 'Both Ways'),
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
                    editor.directionHint.value,
                    style: textStyle.resolve(tokens, [
                      TextSize.label,
                      TextWeight.body,
                      TextColor.muted,
                    ]),
                  ),
                ],
              ),
              SegmentedControl<CardTemplateDirection>(
                options: options,
                value: editor.direction.value,
                onChanged: editor.updateCardType,
                isScrollable: true,
              ),
            ],
          ),
        ),
        CardVerticalAlignmentControl(
          value: editor.template.verticallyCentered,
          onChanged: editor.onVerticalAlignmentControlChanged,
        ),
        FormField<String>(
          value: editor.frontController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Front (Prompt)',
            placeholder: 'Type a word...',
            controller: editor.frontController,
            onChanged: (value) {
              field.didChange(value);
              editor.updateFront(value);
            },
          ),
        ),
        FormField<String>(
          value: editor.backController.text,
          validator: EditDeckFormValidator.answer,
          builder: (_, field) => TextFieldCard(
            title: 'Back (Answer)',
            placeholder: 'Type the translation...',
            controller: editor.backController,
            onChanged: (value) {
              field.didChange(value);
              editor.updateBack(value);
            },
          ),
        ),
      ],
    );
  }
}
