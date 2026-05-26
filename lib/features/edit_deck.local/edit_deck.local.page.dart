// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        QuestionType,
        EditDeckController,
        AppTokens,
        MultipleChoiceOptionData,
        MatchPairData,
        CardType,
        FormatSelector,
        FlashcardEditor,
        MultipleChoiceEditor,
        FillInTheBlanksEditor,
        MatchingTypeEditor,
        ErrorText,
        EditDeckAppbar,
        EditDeckSidebar,
        Button;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

const _visibleQuestionTypes = [
  QuestionType.flashcard,
  QuestionType.multipleChoice,
  QuestionType.fillInTheBlanks,
  QuestionType.matchMadness,
];

class EditDeckPage extends HookWidget {
  const EditDeckPage({
    super.key,
    required this.deckId,
    required this.initialTemplateId,
  });

  final String deckId;
  final String? initialTemplateId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditDeckController(
        deckId: deckId,
        initialTemplateId: initialTemplateId,
      ),
      child: HookBuilder(
        builder: (context) {
          final controller = context.watch<EditDeckController>();
          final formKey = useMemoized(GlobalKey<FormState>.new);
          final titleController = useTextEditingController();
          final formState = controller.formState;
          final questionType = useValueListenable(formState.questionType);
          final cardType = useValueListenable(formState.cardType);
          final multipleChoiceOptions = useValueListenable(
            formState.multipleChoiceOptions,
          );
          final matchPairs = useValueListenable(formState.matchPairs);
          final tokens = context.themeTokens<AppTokens>();

          useEffect(() {
            final deckTitle = controller.deck?.title;
            if (deckTitle != null && titleController.text.isEmpty) {
              titleController.text = deckTitle;
            }
            return null;
          }, [controller.deck?.id, controller.deck?.title]);

          useEffect(() {
            if (!_visibleQuestionTypes.contains(questionType)) {
              formState.questionType.value = QuestionType.flashcard;
              formState.cardType.value = CardType.normal;
            }
            return null;
          }, [questionType]);

          Future<void> handleSaveDeck() async {
            if (formKey.currentState?.validate() ?? true) {
              controller.updateDeckTitle(titleController.text);
              await controller.saveDeck();
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Deck saved'),
                      duration: Duration(seconds: 1),
                    ),
                  );
              }
            }
          }

          final hasActiveTemplate =
              controller.activeTemplateId != null; // <-- Updated
          final selectedFormatIndex =
              _visibleQuestionTypes.contains(questionType)
              ? _visibleQuestionTypes.indexOf(questionType)
              : 0;

          void addTemplate() {
            if (formKey.currentState?.validate() ?? true) {
              controller.addBlankTemplate();
            }
          }

          void selectTemplate(String templateId) {
            if (formKey.currentState?.validate() ?? true) {
              controller.selectTemplate(templateId);
            }
          }

          Widget buildEditor() {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FormatSelector(
                        selectedIndex: selectedFormatIndex,
                        onChanged: (index) {
                          final type = _visibleQuestionTypes[index];
                          formState.questionType.value = type;
                          if (type != QuestionType.flashcard) {
                            formState.cardType.value = CardType.normal;
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      switch (questionType) {
                        QuestionType.flashcard => FlashcardEditor(
                          cardType: cardType,
                          onCardTypeChanged: (value) {
                            formState.cardType.value = value;
                          },
                          frontController: formState.frontController,
                          backController: formState.backController,
                        ),
                        QuestionType.multipleChoice => MultipleChoiceEditor(
                          promptController: formState.frontController,
                          options: multipleChoiceOptions,
                          onOptionAdd: () {
                            formState.multipleChoiceOptions.value = [
                              ...multipleChoiceOptions,
                              const MultipleChoiceOptionData(
                                text: '',
                                isCorrect: false,
                              ),
                            ];
                          },
                          onOptionRemove: (index) {
                            final options = [...multipleChoiceOptions]
                              ..removeAt(index);
                            formState.multipleChoiceOptions.value = options;
                          },
                          onOptionUpdate: (index, option) {
                            final options = [...multipleChoiceOptions];
                            options[index] = option;
                            formState.multipleChoiceOptions.value = options;
                          },
                        ),
                        QuestionType.fillInTheBlanks => FillInTheBlanksEditor(
                          sentenceController:
                              formState.fillInTheBlankSentenceController,
                          answersController:
                              formState.fillInTheBlankAnswersController,
                        ),
                        QuestionType.matchMadness => MatchingTypeEditor(
                          pairs: matchPairs,
                          onPairAdd: () {
                            formState.matchPairs.value = [
                              ...matchPairs,
                              const MatchPairData(term: '', match: ''),
                            ];
                          },
                          onPairRemove: (index) {
                            final pairs = [...matchPairs]..removeAt(index);
                            formState.matchPairs.value = pairs;
                          },
                          onPairUpdate: (index, pair) {
                            final pairs = [...matchPairs];
                            pairs[index] = pair;
                            formState.matchPairs.value = pairs;
                          },
                        ),
                        _ => FlashcardEditor(
                          cardType: cardType,
                          onCardTypeChanged: (value) {
                            formState.cardType.value = value;
                          },
                          frontController: formState.frontController,
                          backController: formState.backController,
                        ),
                      },
                      if (controller.error != null) ...[
                        const SizedBox(height: 16),
                        ErrorText(controller.error!),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            floatingActionButton: MediaQuery.of(context).size.width >= 960
                ? const SizedBox.shrink()
                : FloatingActionButton(
                    onPressed: addTemplate,
                    tooltip: 'Add new card',
                    child: const Icon(Icons.add),
                  ),
            body: Form(
              key: formKey,
              child: CustomScrollView(
                slivers: [
                  EditDeckAppbar(
                    titleController: titleController,
                    onSave: handleSaveDeck,
                    isSaving: controller.isLoading,
                  ),
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        final showSidebar = constraints.maxWidth >= 960;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showSidebar)
                              EditDeckSidebar(
                                templates: controller.templates,
                                activeTemplateId: controller.activeTemplateId,
                                onAdd: addTemplate,
                                onTemplateSelected: selectTemplate,
                              ),
                            Expanded(
                              child: !hasActiveTemplate
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'No card selected',
                                            style: TextStyle(
                                              color: tokens.textPrimary,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Button(
                                            leading: const Icon(Icons.add),
                                            onPressed: addTemplate,
                                            child: const Text('Add Card'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : buildEditor(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
