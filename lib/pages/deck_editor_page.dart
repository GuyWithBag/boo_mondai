// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// PURPOSE: Edit cards in a deck. Cards come from ViewDeckController.
//          The currently selected card is copied into a local useState(draftCard).
//          Saving a card writes draftCard back to ViewDeckController.
//          Saving the deck writes ViewDeckController → Hive.
// PROVIDERS: ViewDeckController
// HOOKS: useState, useEffect, useMemoized, useFocusNode, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DeckEditorPage extends HookWidget {
  const DeckEditorPage({super.key, required this.deckId, this.initialCardId});

  final String deckId;
  final String? initialCardId;

  @override
  Widget build(BuildContext context) {
    final vdc = context.watch<ViewDeckController>();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final frontFocus = useFocusNode();

    // ── Selection + draft state ──────────────────────────────────────
    final selectedCardId = useState<String?>(initialCardId);
    final draftCard = useState<DeckCard?>(null);
    final isSaving = useState(false);

    // Form state
    final qType = useState(QuestionType.flashcard);
    final cType = useState(CardType.normal);
    final frontCtrl = useTextEditingController();
    final backCtrl = useTextEditingController();
    final mcOpts = useState<List<McOpt>>([
      (text: '', isCorrect: true),
      (text: '', isCorrect: false),
      (text: '', isCorrect: false),
    ]);
    final fitbSentCtrl = useTextEditingController();
    final fitbAnsCtrl = useTextEditingController();
    final identificationAnsCtrl = useTextEditingController();
    final matchPairs = useState<List<Pair>>([
      (term: '', match: ''),
      (term: '', match: ''),
      (term: '', match: ''),
    ]);

    // When selectedCardId changes, copy the card from VDC into draftCard
    // and populate form fields.
    useEffect(() {
      final cid = selectedCardId.value;
      if (cid == null) {
        draftCard.value = null;
        return null;
      }
      final card = vdc.cards.where((c) => c.id == cid).firstOrNull;
      if (card == null) return null;

      draftCard.value = card;
      qType.value = card.questionType;
      cType.value = card.cardType;
      frontCtrl.text = card.question;
      backCtrl.text = card.answer;
      identificationAnsCtrl.text = card.identificationAnswer;

      if (card.options.isNotEmpty) {
        mcOpts.value = card.options
            .map((o) => (text: o.optionText, isCorrect: o.isCorrect))
            .toList();
      } else {
        mcOpts.value = [
          (text: '', isCorrect: true),
          (text: '', isCorrect: false),
          (text: '', isCorrect: false),
        ];
      }
      if (card.segments.isNotEmpty) {
        fitbSentCtrl.text = card.segments.first.fullText;
        fitbAnsCtrl.text = card.segments
            .map((seg) => seg.correctAnswer.replaceAll(',', r'\,'))
            .join(',');
      } else {
        fitbSentCtrl.clear();
        fitbAnsCtrl.clear();
      }
      if (card.pairs.isNotEmpty) {
        matchPairs.value = card.pairs
            .map((p) => (term: p.term, match: p.match))
            .toList();
      } else {
        matchPairs.value = [
          (term: '', match: ''),
          (term: '', match: ''),
          (term: '', match: ''),
        ];
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => frontFocus.requestFocus(),
      );
      return null;
    }, [selectedCardId.value]);

    // Build the updated DeckCard from current form state + draftCard
    DeckCard? buildCardFromForm() {
      final card = draftCard.value;
      if (card == null) return null;

      final backTextForSave =
          qType.value.usesIdentificationAnswer ||
              qType.value == QuestionType.wordScramble
          ? ''
          : backCtrl.text.trim();

      final updatedNotes = card.notes
          .map(
            (n) => n == card.primaryNote
                ? n.copyWith(
                    frontText: frontCtrl.text.trim(),
                    backText: backTextForSave,
                  )
                : n,
          )
          .toList();

      return card.copyWith(
        notes: updatedNotes,
        cardType: cType.value,
        questionType: qType.value,
        identificationAnswer: qType.value.usesIdentificationAnswer
            ? identificationAnsCtrl.text.trim()
            : '',
        options: qType.value.usesOptions
            ? buildOptions(mcOpts.value)
            : card.options,
        segments: qType.value.usesSegments
            ? buildSegments(fitbSentCtrl.text, fitbAnsCtrl.text)
            : card.segments,
        pairs: qType.value.usesPairs
            ? buildPairs(matchPairs.value)
            : card.pairs,
      );
    }

    // Save the current draftCard back into ViewDeckController
    void saveCardToController() {
      if (!formKey.currentState!.validate()) return;
      final updated = buildCardFromForm();
      if (updated == null) return;
      context.read<ViewDeckController>().updateCard(updated);
      draftCard.value = updated;
    }

    // Add a blank card to VDC and select it
    void addBlankCard() {
      // Save current card first if one is selected
      if (selectedCardId.value != null) saveCardToController();

      final newCard = buildNewCard(
        deckId,
        cardType: CardType.normal,
        questionType: QuestionType.flashcard,
        sortOrder: vdc.cards.length,
      );
      context.read<ViewDeckController>().addCard(newCard);
      selectedCardId.value = newCard.id;
    }

    // Save entire deck: write VDC draft → Hive
    Future<void> saveDeck() async {
      // Save current card to controller first
      if (selectedCardId.value != null) saveCardToController();

      isSaving.value = true;
      await context.read<ViewDeckController>().save();
      isSaving.value = false;

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

    final hasActiveCard = selectedCardId.value != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Deck'),
        actions: [
          if (vdc.isDirty)
            TextButton(
              onPressed: isSaving.value ? null : saveDeck,
              child: isSaving.value
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
        ],
      ),
      floatingActionButton: LayoutBuilder(
        builder: (ctx, constraints) {
          final showSidebar = constraints.maxWidth >= 960;
          if (showSidebar) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: addBlankCard,
            tooltip: 'Add new card',
            child: const Icon(Icons.add),
          );
        },
      ),
      body: Form(
        key: formKey,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final showSidebar = constraints.maxWidth >= 960;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSidebar)
                  EditorSidebar(
                    cards: vdc.cards,
                    activeCardId: selectedCardId.value,
                    isAdding: false,
                    onAdd: addBlankCard,
                    children: [
                      for (int i = 0; i < vdc.cards.length; i++)
                        SidebarItem(
                          card: vdc.cards[i],
                          isActive: vdc.cards[i].id == selectedCardId.value,
                          onTap: () {
                            // Save current card before switching
                            if (selectedCardId.value != null) {
                              saveCardToController();
                            }
                            selectedCardId.value = vdc.cards[i].id;
                          },
                        ),
                    ],
                  ),
                Expanded(
                  child: !hasActiveCard
                      ? NoCardSelected(
                          onAdd: addBlankCard,
                          isAdding: false,
                        )
                      : EditorMain(
                          qType: qType.value,
                          cType: cType.value,
                          frontCtrl: frontCtrl,
                          backCtrl: backCtrl,
                          identificationAnsCtrl: identificationAnsCtrl,
                          frontFocus: frontFocus,
                          mcOpts: mcOpts.value,
                          fitbSentCtrl: fitbSentCtrl,
                          fitbAnsCtrl: fitbAnsCtrl,
                          matchPairs: matchPairs.value,
                          error: null,
                          onTypeChanged: (t) {
                            qType.value = t;
                            if (!t.canBeReversible) {
                              cType.value = CardType.normal;
                            }
                          },
                          onCardTypeChanged: (ct) => cType.value = ct,
                          onMcAdd: () => mcOpts.value = [
                            ...mcOpts.value,
                            (text: '', isCorrect: false),
                          ],
                          onMcRemove: (i) {
                            final l = [...mcOpts.value];
                            l.removeAt(i);
                            mcOpts.value = l;
                          },
                          onMcUpdate: (i, o) {
                            final l = [...mcOpts.value];
                            l[i] = o;
                            mcOpts.value = l;
                          },
                          onMatchAdd: () => matchPairs.value = [
                            ...matchPairs.value,
                            (term: '', match: ''),
                          ],
                          onMatchRemove: (i) {
                            final l = [...matchPairs.value];
                            l.removeAt(i);
                            matchPairs.value = l;
                          },
                          onMatchUpdate: (i, p) {
                            final l = [...matchPairs.value];
                            l[i] = p;
                            matchPairs.value = l;
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
