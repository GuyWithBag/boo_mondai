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
        MatchingTypeTemplate,
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
    final activeTemplate = editor.selectedTemplate.value;
    final error = editor.error.value;

    if (activeTemplate == null) {
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
          KeyedSubtree(
            key: ValueKey(editor.selectedTemplateKey.value),
            child: switch (activeTemplate) {
              FlashcardTemplate _ => FlashcardEditor(
                editDeckController: editor,
              ),
              MultipleChoiceTemplate _ => MultipleChoiceEditor(
                editDeckController: editor,
              ),
              FillInTheBlanksTemplate _ => FillInTheBlanksEditor(
                editDeckController: editor,
              ),
              IdentificationTemplate _ => IdentificationEditor(
                editDeckController: editor,
              ),
              MatchingTypeTemplate _ => MatchingTypeEditor(
                editDeckController: editor,
              ),
              WordScrambleTemplate _ => WordScrambleEditor(
                editDeckController: editor,
              ),
              _ => StatusLayoutState(
                icon: Icons.help_outline,
                title: 'Unsupported card',
                message: 'This card template type is not supported here.',
              ),
            },
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            ErrorText.exception(error),
          ],
        ],
      ),
    );
  }
}
