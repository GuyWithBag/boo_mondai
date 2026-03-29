// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor_page.dart
// PURPOSE: Edit all cards in a deck — sidebar shows all cards, clicking
//          one selects it; "+" creates a blank card and immediately selects it
// PROVIDERS: CardProvider
// HOOKS: useState, useEffect, useMemoized, useFocusNode, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DeckEditorPage extends HookWidget {
  /// [initialCardId] optionally pre-selects a card when the page opens
  /// (e.g. when navigating from the deck detail card list).
  const DeckEditorPage({super.key, required this.deckId, this.initialCardId});

  final String deckId;
  final String? initialCardId;

  @override
  Widget build(BuildContext context) {
    final cardProvider = context.watch<CardProvider>();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final frontFocus = useFocusNode();

    // Active card is tracked as internal state — no URL param needed
    final activeCardId = useState<String?>(initialCardId);
    final isAdding = useState(false);

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

    // Reload form whenever the active card changes
    useEffect(() {
      final cid = activeCardId.value;
      if (cid == null) return null;
      final card = cardProvider.cards.where((c) => c.id == cid).firstOrNull;
      if (card == null) return null;

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
        // Re-encode: escape commas inside each answer, then join with ','
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
    }, [activeCardId.value]);

    // Creates a blank card in DB, adds it to the sidebar, and selects it
    Future<void> addBlankCard() async {
      isAdding.value = true;
      final newCard = await context.read<CardProvider>().addCard(
        deckId,
        cardType: CardType.normal,
        questionType: QuestionType.flashcard,
      );
      isAdding.value = false;
      if (newCard != null) {
        activeCardId.value = newCard.id;
      }
    }

    // Save always updates (card already exists after addBlankCard)
    Future<void> save() async {
      if (activeCardId.value == null) return;
      if (!formKey.currentState!.validate()) return;
      final card = cardProvider.cards
          .where((c) => c.id == activeCardId.value)
          .firstOrNull;
      if (card == null) return;

      // identification and wordScramble only use frontText; backText is not shown
      // and should not be written back (keeps the field clean).
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

      await context.read<CardProvider>().updateCard(
        card.copyWith(
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
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Card saved'),
              duration: Duration(seconds: 1),
            ),
          );
      }
    }

    final hasActiveCard = activeCardId.value != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Deck'),
        actions: [
          if (cardProvider.isDirty(deckId))
            EditorPushButton(
              isPushing: cardProvider.isPushing,
              onPressed: cardProvider.isPushing
                  ? null
                  : () => context.read<CardProvider>().pushDeck(deckId),
            ),
          if (hasActiveCard)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: FilledButton(
                onPressed: cardProvider.isLoading ? null : save,
                child: const Text('Save Card'),
              ),
            ),
        ],
      ),
      // On mobile (no sidebar), FAB lets the user add a new card
      floatingActionButton: LayoutBuilder(
        builder: (ctx, constraints) {
          final showSidebar = constraints.maxWidth >= 960;
          if (showSidebar) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: isAdding.value ? null : addBlankCard,
            tooltip: 'Add new card',
            child: isAdding.value
                ? const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
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
                    cards: cardProvider.cards,
                    activeCardId: activeCardId.value,
                    isAdding: isAdding.value,
                    onSelect: (id) => activeCardId.value = id,
                    onAdd: addBlankCard,
                  ),
                Expanded(
                  child: !hasActiveCard
                      ? NoCardSelected(
                          onAdd: addBlankCard,
                          isAdding: isAdding.value,
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
                          error: cardProvider.error,
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
