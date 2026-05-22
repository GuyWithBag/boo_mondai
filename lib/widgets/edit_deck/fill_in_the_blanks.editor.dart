import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import '../../variant_styles/variant_styles.barrel.dart';
import '../../widgets/text_field_card.dart';
import '../../widgets/tactile_button.dart';
import 'hooks/use_fill_in_the_blanks_editor.dart';

class FillInTheBlanksEditor extends HookWidget {
  const FillInTheBlanksEditor({
    required this.sentenceController,
    required this.answersController,
    super.key,
  });

  final TextEditingController sentenceController;
  final TextEditingController answersController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useFillInTheBlanksEditor(
      sentenceController: sentenceController,
      answersController: answersController,
    );

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceTone.surface]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sentence Builder'.toUpperCase(),
            style: appTextStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextTone.muted,
            ]),
          ),
          const SizedBox(height: 14),
          Text(
            'Type your full sentence below. Highlight the words you want the user to guess, and click "Create Blank".',
            style: appTextStyle
                .resolve(tokens, [
                  TextSize.label,
                  TextWeight.body,
                  TextTone.secondary,
                ])
                .copyWith(fontSize: 17),
          ),
          const SizedBox(height: 28),
          TextFieldCard(
            title: 'Full Sentence',
            placeholder: 'Type the full sentence...',
            controller: sentenceController,
            minHeight: 240,
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: TactileButton(
              leading: const Icon(Icons.cleaning_services),
              onPressed: editor.canCreateBlank
                  ? editor.createBlankFromSelection
                  : null,
              child: const Text('Create Blank'),
            ),
          ),
          const SizedBox(height: 18),
          TextFieldCard(
            title: 'Answers',
            placeholder: 'Separate blank answers with commas...',
            controller: answersController,
            minHeight: 180,
          ),
          if (editor.sentence.trim().isNotEmpty ||
              editor.answers.isNotEmpty) ...[
            const SizedBox(height: 18),
            Surface(
              style: surfaceStyle.resolve(tokens, const [SurfaceTone.muted]),
              child: Text(
                editor.previewSentence,
                style: TextStyle(
                  color: tokens.textPrimary,
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
            style: appTextStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextTone.primary,
            ]),
          ),
          const SizedBox(height: 14),
          if (editor.answers.isEmpty)
            Text(
              'No blanks yet.',
              style: appTextStyle.resolve(tokens, [
                TextSize.label,
                TextWeight.body,
                TextTone.secondary,
              ]),
            )
          else
            for (final entry in editor.answers.asMap().entries) ...[
              Surface(
                style: surfaceStyle.resolve(tokens, const [SurfaceTone.muted]),
                child: Row(
                  children: [
                    TactileButton(
                      size: TactileSize.lg,
                      child: Text('${entry.key + 1}'),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Correct Answer'.toUpperCase(),
                            style: appTextStyle.resolve(tokens, [
                              TextSize.labelSmall,
                              TextWeight.heavy,
                              TextTone.muted,
                            ]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.value,
                            style: TextStyle(
                              color: tokens.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => editor.removeBlankAt(entry.key),
                      icon: Icon(Icons.delete, color: tokens.actionError),
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
