import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        EditDeckController,
        ErrorText,
        FillInTheBlanksEditor,
        MatchingTypeEditor,
        QuestionType,
        FlashcardEditor,
        MultipleChoiceEditor;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckEditorBody extends StatelessWidget {
  const EditDeckEditorBody({required this.editor, super.key});

  final EditDeckController editor;

  @override
  Widget build(BuildContext context) {
    if (!editor.hasActiveTemplate) {
      return _NoCardSelected(onAdd: editor.addTemplate);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          switch (editor.questionType) {
            QuestionType.flashcard => FlashcardEditor(
              formState: editor.formState,
            ),
            QuestionType.multipleChoice => MultipleChoiceEditor(
              formState: editor.formState,
            ),
            QuestionType.fillInTheBlanks => FillInTheBlanksEditor(
              formState: editor.formState,
            ),
            QuestionType.matchMadness => MatchingTypeEditor(
              formState: editor.formState,
            ),
            _ => FlashcardEditor(formState: editor.formState),
          },
          if (editor.error != null) ...[
            const SizedBox(height: 16),
            ErrorText(editor.error!),
          ],
        ],
      ),
    );
  }
}

class _NoCardSelected extends StatelessWidget {
  const _NoCardSelected({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No card selected',
            style: TextStyle(
              color: tokens.colorTextBaseline,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Button(
            leading: const Icon(Icons.add),
            onPressed: onAdd,
            child: const Text('Add Card'),
          ),
        ],
      ),
    );
  }
}
