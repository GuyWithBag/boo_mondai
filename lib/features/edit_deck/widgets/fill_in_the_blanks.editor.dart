import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        DeckCardFormState,
        useFillInTheBlanksEditorController,
        surfaceStyle,
        SurfaceColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        TextFieldCard,
        Button,
        ButtonSize;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlanksEditor extends HookWidget {
  const FillInTheBlanksEditor({required this.formState, super.key});

  final DeckCardFormState formState;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useFillInTheBlanksEditorController(formState);
    final fillInTheBlanksEditor = editor.state;

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sentence Builder'.toUpperCase(),
            style: textStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextColor.muted,
            ]),
          ),
          const SizedBox(height: 14),
          Text(
            'Type your full sentence below. Highlight the words you want the user to guess, and click "Create Blank".',
            style: textStyle
                .resolve(tokens, [
                  TextSize.label,
                  TextWeight.body,
                  TextColor.muted,
                ])
                .copyWith(fontSize: 17),
          ),
          const SizedBox(height: 28),
          TextFieldCard(
            title: 'Full Sentence',
            placeholder: 'Type the full sentence...',
            controller: editor.sentenceController,
            minHeight: 240,
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Button(
              leading: const Icon(Icons.cleaning_services),
              onPressed: fillInTheBlanksEditor.canCreateBlank
                  ? fillInTheBlanksEditor.createBlankFromSelection
                  : null,
              child: const Text('Create Blank'),
            ),
          ),
          const SizedBox(height: 18),
          TextFieldCard(
            title: 'Answers',
            placeholder: 'Separate blank answers with commas...',
            controller: editor.answersController,
            minHeight: 180,
          ),
          if (fillInTheBlanksEditor.sentence.trim().isNotEmpty ||
              fillInTheBlanksEditor.answers.isNotEmpty) ...[
            const SizedBox(height: 18),
            Surface(
              style: surfaceStyle.resolve(tokens, const [SurfaceColor.muted]),
              child: Text(
                fillInTheBlanksEditor.previewSentence,
                style: TextStyle(
                  color: tokens.colorTextBaseline,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
            ),
          ],
          const SizedBox(height: 36),
          Text(
            'Hidden Segments'.toUpperCase(),
            style: textStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
            ]),
          ),
          const SizedBox(height: 14),
          if (fillInTheBlanksEditor.answers.isEmpty)
            Text(
              'No blanks yet.',
              style: textStyle.resolve(tokens, [
                TextSize.label,
                TextWeight.body,
                TextColor.muted,
              ]),
            )
          else
            for (final entry
                in fillInTheBlanksEditor.answers.asMap().entries) ...[
              Surface(
                style: surfaceStyle.resolve(tokens, const [SurfaceColor.muted]),
                child: Row(
                  children: [
                    Button(
                      variants: const [ButtonSize.lg],
                      child: Text('${entry.key + 1}'),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Correct Answer'.toUpperCase(),
                            style: textStyle.resolve(tokens, [
                              TextSize.labelSmall,
                              TextWeight.heavy,
                              TextColor.muted,
                            ]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.value,
                            style: TextStyle(
                              color: tokens.colorTextBaseline,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          fillInTheBlanksEditor.removeBlankAt(entry.key),
                      icon: Icon(Icons.delete, color: tokens.colorActionError),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}
