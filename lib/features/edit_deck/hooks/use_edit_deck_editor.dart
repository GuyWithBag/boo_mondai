import 'package:boo_mondai/lib.barrel.dart'
    show
        CardType,
        CardTemplateFormState,
        EditDeckController,
        EditDeckQuestionTypeHelper,
        QuestionType;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditDeckEditorController {
  const EditDeckEditorController({
    required this.deckController,
    required this.formKey,
    required this.titleController,
    required this.questionType,
  });

  final EditDeckController deckController;
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final QuestionType questionType;

  CardTemplateFormState get formState => deckController.formState;
  String? get activeTemplateId => deckController.activeTemplateId;
  bool get hasActiveTemplate => activeTemplateId != null;
  bool get isSaving => deckController.isLoading;
  Exception? get error => deckController.error;
  int get selectedFormatIndex =>
      EditDeckQuestionTypeHelper.selectedFormatIndex(questionType);

  bool validate() => formKey.currentState?.validate() ?? true;

  void setFormatIndex(int index) {
    setQuestionType(EditDeckQuestionTypeHelper.questionTypeAt(index));
  }

  void setQuestionType(QuestionType value) {
    formState.questionType.value = value;
    formState.cardType.value =
        EditDeckQuestionTypeHelper.cardTypeForQuestionType(
          value,
          formState.cardType.value,
        );
  }

  void ensureVisibleQuestionType() {
    if (EditDeckQuestionTypeHelper.isVisible(questionType)) return;

    formState.questionType.value = QuestionType.flashcard;
    formState.cardType.value = CardType.normal;
  }

  void addTemplate() {
    if (!validate()) return;
    deckController.addBlankTemplate();
  }

  void selectTemplate(String templateId) {
    if (!validate()) return;
    deckController.selectTemplate(templateId);
  }

  Future<bool> saveDeck() async {
    if (!validate()) return false;

    deckController.updateDeckTitle(titleController.text);
    await deckController.saveDeck();
    return deckController.error == null;
  }
}

EditDeckEditorController useEditDeckEditor(EditDeckController deckController) {
  final formKey = useMemoized(GlobalKey<FormState>.new);
  final titleController = useTextEditingController();
  final formState = deckController.formState;
  final questionType = useValueListenable(formState.questionType);

  useEffect(() {
    final deckTitle = deckController.deck?.title;
    if (deckTitle != null && titleController.text.isEmpty) {
      titleController.text = deckTitle;
    }
    return null;
  }, [deckController.deck?.id, deckController.deck?.title]);

  final editor = EditDeckEditorController(
    deckController: deckController,
    formKey: formKey,
    titleController: titleController,
    questionType: questionType,
  );

  useEffect(() {
    editor.ensureVisibleQuestionType();
    return null;
  }, [questionType]);

  return editor;
}
