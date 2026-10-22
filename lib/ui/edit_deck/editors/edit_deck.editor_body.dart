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
  const EditDeckEditorBody({required this.controller, super.key});

  final EditDeckController controller;

  @override
  Widget build(BuildContext context) {
    final activeTemplate = controller.selectedTemplate.value;
    final error = controller.error.value;

    if (activeTemplate == null) {
      return StatusLayoutState(
        icon: Icons.style_outlined,
        title: 'No card selected',
        message: 'Add a card to start editing this deck.',
        actions: [
          Button(
            leading: const Icon(Icons.add),
            onPressed: () => controller.addTemplate(context),
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
            key: ValueKey(controller.selectedTemplateKey.value),
            child: switch (activeTemplate) {
              FlashcardTemplate _ => FlashcardEditor(
                editDeckController: controller,
              ),
              MultipleChoiceTemplate _ => MultipleChoiceEditor(
                editDeckController: controller,
              ),
              FillInTheBlanksTemplate _ => FillInTheBlanksEditor(
                editDeckController: controller,
              ),
              IdentificationTemplate _ => IdentificationEditor(
                editDeckController: controller,
              ),
              MatchingTypeTemplate _ => MatchingTypeEditor(
                editDeckController: controller,
              ),
              WordScrambleTemplate _ => WordScrambleEditor(
                editDeckController: controller,
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
