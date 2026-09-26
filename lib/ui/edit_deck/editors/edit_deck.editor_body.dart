import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        EditDeckController,
        ErrorText,
        FillInTheBlanksTemplate,
        FillInTheBlanksEditor,
        FlashcardTemplate,
        IdentificationEditor,
        IdentificationTemplate,
        MatchMadnessTemplate,
        MatchingTypeEditor,
        FlashcardEditor,
        MultipleChoiceEditor,
        MultipleChoiceTemplate,
        StatusLayoutState,
        WordScrambleTemplate,
        WordScrambleEditor;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';

class EditDeckEditorBody extends SignalHookWidget {
  const EditDeckEditorBody({required this.editor, super.key});

  final EditDeckController editor;

  @override
  Widget build(BuildContext context) {
    final hasActiveTemplate = editor.hasCurrentTemplate.value;
    final currentTemplate = editor.currentTemplate.value;
    final error = editor.error.value;

    if (!hasActiveTemplate) {
      return StatusLayoutState(
        icon: Icons.style_outlined,
        title: 'No card selected',
        message: 'Add a card to start editing this deck.',
        actions: [
          Button(
            leading: const Icon(Icons.add),
            onPressed: editor.addTemplate,
            child: const Text('Add Card'),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          switch (currentTemplate!) {
            FlashcardTemplate template => FlashcardEditor(
              template: template,
              onChanged: editor.updateTemplate,
            ),
            MultipleChoiceTemplate template => MultipleChoiceEditor(
              template: template,
              onChanged: editor.updateTemplate,
            ),
            FillInTheBlanksTemplate template => FillInTheBlanksEditor(
              template: template,
              onChanged: editor.updateTemplate,
            ),
            IdentificationTemplate template => IdentificationEditor(
              template: template,
              onChanged: editor.updateTemplate,
            ),
            MatchMadnessTemplate template => MatchingTypeEditor(
              template: template,
              onChanged: editor.updateTemplate,
            ),
            WordScrambleTemplate template => WordScrambleEditor(
              template: template,
              onChanged: editor.updateTemplate,
            ),
            _ => StatusLayoutState(
              icon: Icons.help_outline,
              title: 'Unsupported card',
              message: 'This card template type is not supported here.',
            ),
          },
          if (error != null) ...[
            const SizedBox(height: 16),
            ErrorText.exception(error),
          ],
        ],
      ),
    );
  }
}
