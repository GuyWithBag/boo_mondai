import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckCardFormState,
        FillInTheBlanksEditorState,
        useFillInTheBlanksEditor;
import 'package:flutter/material.dart';

class FillInTheBlanksEditorController {
  const FillInTheBlanksEditorController({
    required this.formState,
    required this.state,
  });

  final DeckCardFormState formState;
  final FillInTheBlanksEditorState state;

  TextEditingController get sentenceController =>
      formState.fillInTheBlankSentenceController;
  TextEditingController get answersController =>
      formState.fillInTheBlankAnswersController;
}

FillInTheBlanksEditorController useFillInTheBlanksEditorController(
  DeckCardFormState formState,
) {
  final state = useFillInTheBlanksEditor(
    sentenceController: formState.fillInTheBlankSentenceController,
    answersController: formState.fillInTheBlankAnswersController,
  );

  return FillInTheBlanksEditorController(formState: formState, state: state);
}
