import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckCardFormState,
        TextFieldCard,
        MultipleChoiceOptionsPanel,
        useMultipleChoiceEditor;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'responsive_two_column.dart';

class MultipleChoiceEditor extends HookWidget {
  const MultipleChoiceEditor({required this.formState, super.key});

  final DeckCardFormState formState;

  @override
  Widget build(BuildContext context) {
    final editor = useMultipleChoiceEditor(formState);

    return ResponsiveTwoColumn(
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
