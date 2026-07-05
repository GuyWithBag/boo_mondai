import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplateFormState,
        TextFieldCard,
        MultipleChoiceOptionsPanel,
        useMultipleChoiceEditor,
        AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceEditor extends HookWidget {
  const MultipleChoiceEditor({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final editor = useMultipleChoiceEditor(formState);
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        TextFieldCard(
          title: 'Front (Prompt)',
          placeholder: 'Type a question...',
          controller: editor.promptController,
        ),
        MultipleChoiceOptionsPanel(controller: editor),
      ],
    );
  }
}
