// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/card_editor_page.dart
// PURPOSE: Add or edit a card — supports all six question types
// PROVIDERS: CardProvider
// HOOKS: useState, useEffect, useMemoized, useFocusNode, useTextEditingController, useListenable
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

typedef _McOpt = ({String text, bool isCorrect});
typedef _Pair = ({String term, String match});

// ── Module-level data helpers ─────────────────────────────────────

List<MultipleChoiceOption> _buildOptions(List<_McOpt> opts) => [
  for (var i = 0; i < opts.length; i++)
    if (opts[i].text.trim().isNotEmpty)
      MultipleChoiceOption(
        id: '',
        cardId: '',
        optionText: opts[i].text.trim(),
        isCorrect: opts[i].isCorrect,
        displayOrder: i,
      ),
];

List<FillInTheBlankSegment> _buildSegment(String sentence, String answer) {
  final s = sentence.trim();
  final a = answer.trim();
  if (s.isEmpty || a.isEmpty) return [];
  final idx = s.toLowerCase().indexOf(a.toLowerCase());
  if (idx < 0) return [];
  return [
    FillInTheBlankSegment(
      id: '',
      cardId: '',
      fullText: s,
      blankStart: idx,
      blankEnd: idx + a.length,
      correctAnswer: a,
    ),
  ];
}

List<MatchMadnessPair> _buildPairs(List<_Pair> ps) => [
  for (var i = 0; i < ps.length; i++)
    if (ps[i].term.trim().isNotEmpty && ps[i].match.trim().isNotEmpty)
      MatchMadnessPair(
        id: '',
        cardId: '',
        term: ps[i].term.trim(),
        match: ps[i].match.trim(),
        isAutoPicked: false,
        displayOrder: i,
      ),
];

// ── Main page ─────────────────────────────────────────────────────

class CardEditorPage extends HookWidget {
  const CardEditorPage({super.key, required this.deckId, this.cardId});

  final String deckId;
  final String? cardId;

  @override
  Widget build(BuildContext context) {
    final cardProvider = context.watch<CardProvider>();
    final isEdit = cardId != null;
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final frontFocus = useFocusNode();
    final qType = useState(QuestionType.readAndSelect);
    final cType = useState(CardType.normal);
    final frontCtrl = useTextEditingController();
    final backCtrl = useTextEditingController();
    final mcOpts = useState<List<_McOpt>>([
      (text: '', isCorrect: true),
      (text: '', isCorrect: false),
      (text: '', isCorrect: false),
    ]);
    final fitbSentCtrl = useTextEditingController();
    final fitbAnsCtrl = useTextEditingController();
    final matchPairs = useState<List<_Pair>>([
      (term: '', match: ''),
      (term: '', match: ''),
      (term: '', match: ''),
    ]);

    useEffect(() {
      frontFocus.requestFocus();
      if (!isEdit) return null;
      final card = cardProvider.cards.where((c) => c.id == cardId).firstOrNull;
      if (card == null) return null;
      qType.value = card.questionType;
      cType.value = card.cardType;
      frontCtrl.text = card.question;
      backCtrl.text = card.answer;
      if (card.options.isNotEmpty) {
        mcOpts.value = card.options
            .map((o) => (text: o.optionText, isCorrect: o.isCorrect))
            .toList();
      }
      if (card.segments.isNotEmpty) {
        fitbSentCtrl.text = card.segments.first.fullText;
        fitbAnsCtrl.text = card.segments.first.correctAnswer;
      }
      if (card.pairs.isNotEmpty) {
        matchPairs.value =
            card.pairs.map((p) => (term: p.term, match: p.match)).toList();
      }
      return null;
    }, [cardId]);

    Future<void> save() async {
      if (!formKey.currentState!.validate()) return;
      if (isEdit) {
        final card =
            cardProvider.cards.where((c) => c.id == cardId).firstOrNull;
        if (card == null) return;
        final updatedNotes = card.notes
            .map((n) => n == card.primaryNote
                ? n.copyWith(
                    frontText: frontCtrl.text.trim(),
                    backText: backCtrl.text.trim())
                : n)
            .toList();
        await context.read<CardProvider>().updateCard(
              card.copyWith(
                  notes: updatedNotes,
                  cardType: cType.value,
                  questionType: qType.value),
            );
      } else {
        await context.read<CardProvider>().addCard(
              deckId,
              cardType: cType.value,
              questionType: qType.value,
              frontText: frontCtrl.text.trim(),
              backText: backCtrl.text.trim(),
              options:
                  qType.value.usesOptions ? _buildOptions(mcOpts.value) : [],
              segments: qType.value.usesSegments
                  ? _buildSegment(fitbSentCtrl.text, fitbAnsCtrl.text)
                  : [],
              pairs:
                  qType.value.usesPairs ? _buildPairs(matchPairs.value) : [],
            );
      }
      if (context.mounted) Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Card' : 'New Card'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: FilledButton(
              onPressed: cardProvider.isLoading ? null : save,
              child: const Text('Save Card'),
            ),
          ),
        ],
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
                  _EditorSidebar(
                      cards: cardProvider.cards, activeCardId: cardId),
                Expanded(
                  child: _EditorMain(
                    qType: qType.value,
                    cType: cType.value,
                    frontCtrl: frontCtrl,
                    backCtrl: backCtrl,
                    frontFocus: frontFocus,
                    mcOpts: mcOpts.value,
                    fitbSentCtrl: fitbSentCtrl,
                    fitbAnsCtrl: fitbAnsCtrl,
                    matchPairs: matchPairs.value,
                    error: cardProvider.error,
                    onTypeChanged: (t) {
                      qType.value = t;
                      if (!t.canBeReversible) cType.value = CardType.normal;
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

// ── Sidebar ───────────────────────────────────────────────────────

class _EditorSidebar extends StatelessWidget {
  const _EditorSidebar({required this.cards, this.activeCardId});

  final List<DeckCard> cards;
  final String? activeCardId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          right: BorderSide(color: scheme.surfaceContainerHighest),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            child: Text(
              'Cards in Deck (${cards.length})',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: cards.isEmpty
                ? const Center(
                    child: Text(
                      'No cards yet',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (ctx, i) => _SidebarItem(
                      card: cards[i],
                      isActive: cards[i].id == activeCardId,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.card, required this.isActive});

  final DeckCard card;
  final bool isActive;

  static const _icons = <QuestionType, IconData>{
    QuestionType.readAndSelect: Icons.visibility_outlined,
    QuestionType.multipleChoice: Icons.checklist_outlined,
    QuestionType.fillInTheBlanks: Icons.edit_note_outlined,
    QuestionType.readAndComplete: Icons.spellcheck_outlined,
    QuestionType.listenAndType: Icons.headphones_outlined,
    QuestionType.matchMadness: Icons.compare_arrows_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: isActive ? scheme.primary.withValues(alpha: 0.08) : null,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      child: Row(
        children: [
          Icon(
            _icons[card.questionType] ?? Icons.help_outline,
            size: 15,
            color: isActive ? scheme.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              card.question.isNotEmpty ? card.question : '(empty)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? scheme.primary : null,
                    fontWeight: isActive ? FontWeight.w600 : null,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Editor main content ───────────────────────────────────────────

class _EditorMain extends StatelessWidget {
  const _EditorMain({
    required this.qType,
    required this.cType,
    required this.frontCtrl,
    required this.backCtrl,
    required this.frontFocus,
    required this.mcOpts,
    required this.fitbSentCtrl,
    required this.fitbAnsCtrl,
    required this.matchPairs,
    this.error,
    required this.onTypeChanged,
    required this.onCardTypeChanged,
    required this.onMcAdd,
    required this.onMcRemove,
    required this.onMcUpdate,
    required this.onMatchAdd,
    required this.onMatchRemove,
    required this.onMatchUpdate,
  });

  final QuestionType qType;
  final CardType cType;
  final TextEditingController frontCtrl;
  final TextEditingController backCtrl;
  final FocusNode frontFocus;
  final List<_McOpt> mcOpts;
  final TextEditingController fitbSentCtrl;
  final TextEditingController fitbAnsCtrl;
  final List<_Pair> matchPairs;
  final String? error;
  final void Function(QuestionType) onTypeChanged;
  final void Function(CardType) onCardTypeChanged;
  final VoidCallback onMcAdd;
  final void Function(int) onMcRemove;
  final void Function(int, _McOpt) onMcUpdate;
  final VoidCallback onMatchAdd;
  final void Function(int) onMatchRemove;
  final void Function(int, _Pair) onMatchUpdate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeBar(selected: qType, onChanged: onTypeChanged),
              if (qType.canBeReversible) ...[
                const SizedBox(height: AppSpacing.lg),
                _DirectionBar(
                    selected: cType, onChanged: onCardTypeChanged),
              ],
              const SizedBox(height: AppSpacing.xl),
              if (qType.usesSegments)
                _FitbEditor(
                    sentCtrl: fitbSentCtrl, ansCtrl: fitbAnsCtrl)
              else if (qType.usesPairs)
                _MatchEditor(
                  pairs: matchPairs,
                  onAdd: onMatchAdd,
                  onRemove: onMatchRemove,
                  onUpdate: onMatchUpdate,
                )
              else
                _LeftPanel(
                  qType: qType,
                  frontCtrl: frontCtrl,
                  backCtrl: backCtrl,
                  frontFocus: frontFocus,
                  mcOpts: mcOpts,
                  onMcAdd: onMcAdd,
                  onMcRemove: onMcRemove,
                  onMcUpdate: onMcUpdate,
                ),
              if (error != null) ...[
                const SizedBox(height: AppSpacing.md),
                ErrorText(error!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Type selector ─────────────────────────────────────────────────

class _TypeBar extends StatelessWidget {
  const _TypeBar({required this.selected, required this.onChanged});

  final QuestionType selected;
  final void Function(QuestionType) onChanged;

  static const _types = [
    (
      QuestionType.readAndSelect,
      'Read & Select',
      Icons.visibility_outlined
    ),
    (
      QuestionType.multipleChoice,
      'Multiple Choice',
      Icons.checklist_outlined
    ),
    (
      QuestionType.fillInTheBlanks,
      'Fill in Blank',
      Icons.edit_note_outlined
    ),
    (
      QuestionType.matchMadness,
      'Match Madness',
      Icons.compare_arrows_outlined
    ),
    (
      QuestionType.listenAndType,
      'Listen & Type',
      Icons.headphones_outlined
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question Type',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _types
                .map((e) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: _TypeButton(
                        label: e.$2,
                        icon: e.$3,
                        selected: selected == e.$1,
                        onTap: () => onChanged(e.$1),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = selected ? scheme.primary : scheme.surfaceContainerHighest;
    final fg = selected ? scheme.onPrimary : AppColors.textSecondary;
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          width: 96,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadii.card),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 26),
              const SizedBox(height: AppSpacing.xs + 2),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: fg,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      height: 1.2,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card direction bar ────────────────────────────────────────────

class _DirectionBar extends StatelessWidget {
  const _DirectionBar({required this.selected, required this.onChanged});

  final CardType selected;
  final void Function(CardType) onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: scheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Direction',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Choose how this card will be quizzed',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<CardType>(
            segments: const [
              ButtonSegment(
                  value: CardType.normal,
                  label: Text('Normal'),
                  icon: Icon(Icons.arrow_forward, size: 16)),
              ButtonSegment(
                  value: CardType.reversible,
                  label: Text('Reversible'),
                  icon: Icon(Icons.swap_horiz, size: 16)),
              ButtonSegment(
                  value: CardType.both,
                  label: Text('Both'),
                  icon: Icon(Icons.sync_alt, size: 16)),
            ],
            selected: {selected},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ],
      ),
    );
  }
}

// ── Input card panel ──────────────────────────────────────────────

class _InputCard extends StatelessWidget {
  const _InputCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: scheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Left panel (R&S / MC / Listen) ───────────────────────────────

class _LeftPanel extends StatelessWidget {
  const _LeftPanel({
    required this.qType,
    required this.frontCtrl,
    required this.backCtrl,
    required this.frontFocus,
    required this.mcOpts,
    required this.onMcAdd,
    required this.onMcRemove,
    required this.onMcUpdate,
  });

  final QuestionType qType;
  final TextEditingController frontCtrl;
  final TextEditingController backCtrl;
  final FocusNode frontFocus;
  final List<_McOpt> mcOpts;
  final VoidCallback onMcAdd;
  final void Function(int) onMcRemove;
  final void Function(int, _McOpt) onMcUpdate;

  @override
  Widget build(BuildContext context) {
    final isMc = qType == QuestionType.multipleChoice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputCard(
          label: qType == QuestionType.listenAndType ? 'AUDIO PROMPT' : 'FRONT',
          child: TextFormField(
            controller: frontCtrl,
            focusNode: frontFocus,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: qType == QuestionType.listenAndType
                  ? 'Text for audio playback'
                  : 'e.g. 犬',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _InputCard(
          label: isMc ? 'HINT (OPTIONAL)' : 'BACK',
          child: TextFormField(
            controller: backCtrl,
            maxLines: isMc ? 2 : 3,
            decoration: InputDecoration(
              hintText: isMc
                  ? 'Optional hint shown after answering'
                  : 'e.g. dog, いぬ, inu',
              helperText:
                  isMc ? null : 'Separate multiple accepted answers with commas',
            ),
            validator: isMc
                ? null
                : (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
        ),
        if (isMc) ...[
          const SizedBox(height: AppSpacing.md),
          _McPanel(
            options: mcOpts,
            onAdd: onMcAdd,
            onRemove: onMcRemove,
            onUpdate: onMcUpdate,
          ),
        ],
      ],
    );
  }
}

// ── Multiple choice panel ─────────────────────────────────────────

class _McPanel extends StatelessWidget {
  const _McPanel({
    required this.options,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdate,
  });

  final List<_McOpt> options;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final void Function(int, _McOpt) onUpdate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: scheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ANSWER OPTIONS',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
              ),
              const Spacer(),
              if (options.length < 6)
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...options.asMap().entries.map(
                (e) => _McRow(
                  index: e.key,
                  option: e.value,
                  canRemove: options.length > 2,
                  onRemove: () => onRemove(e.key),
                  onChanged: (o) => onUpdate(e.key, o),
                ),
              ),
        ],
      ),
    );
  }
}

class _McRow extends HookWidget {
  const _McRow({
    required this.index,
    required this.option,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  final int index;
  final _McOpt option;
  final bool canRemove;
  final VoidCallback onRemove;
  final void Function(_McOpt) onChanged;

  @override
  Widget build(BuildContext context) {
    final ctrl = useTextEditingController(text: option.text);
    useEffect(() {
      if (ctrl.text != option.text) {
        ctrl.text = option.text;
        ctrl.selection =
            TextSelection.collapsed(offset: option.text.length);
      }
      return null;
    }, [option.text]);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Tooltip(
            message:
                option.isCorrect ? 'Correct answer' : 'Mark as correct',
            child: GestureDetector(
              onTap: () =>
                  onChanged((text: option.text, isCorrect: !option.isCorrect)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option.isCorrect
                      ? AppColors.correct.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: option.isCorrect
                        ? AppColors.correct
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: option.isCorrect
                    ? const Icon(Icons.check,
                        size: 16, color: AppColors.correct)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              child: TextField(
                controller: ctrl,
                decoration:
                    InputDecoration(hintText: 'Option ${index + 1}'),
                onChanged: (v) =>
                    onChanged((text: v, isCorrect: option.isCorrect)),
              ),
            ),
          ),
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onRemove,
              tooltip: 'Remove',
              color: AppColors.textSecondary,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// ── Fill in the Blank editor ──────────────────────────────────────

class _FitbEditor extends HookWidget {
  const _FitbEditor({required this.sentCtrl, required this.ansCtrl});

  final TextEditingController sentCtrl;
  final TextEditingController ansCtrl;

  @override
  Widget build(BuildContext context) {
    useListenable(sentCtrl);
    useListenable(ansCtrl);

    final hasContent =
        sentCtrl.text.trim().isNotEmpty && ansCtrl.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InputCard(
          label: 'FULL SENTENCE',
          child: TextFormField(
            controller: sentCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'e.g. 魚 means fish in English',
              helperText:
                  'Write the complete sentence — include the answer word',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _InputCard(
          label: 'ANSWER WORD',
          child: TextFormField(
            controller: ansCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. fish',
              helperText: 'This exact word will be replaced with a blank',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              final sentence = sentCtrl.text.trim().toLowerCase();
              if (!sentence.contains(v.trim().toLowerCase())) {
                return 'Word not found in the sentence above';
              }
              return null;
            },
          ),
        ),
        if (hasContent) ...[
          const SizedBox(height: AppSpacing.md),
          _FitbPreview(sentence: sentCtrl.text, answer: ansCtrl.text),
        ],
      ],
    );
  }
}

class _FitbPreview extends StatelessWidget {
  const _FitbPreview({required this.sentence, required this.answer});

  final String sentence;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final idx =
        sentence.toLowerCase().indexOf(answer.trim().toLowerCase());

    if (idx < 0) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.incorrect.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadii.card),
          border:
              Border.all(color: AppColors.incorrect.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 16, color: AppColors.incorrect),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Answer word not found in sentence',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.incorrect),
            ),
          ],
        ),
      );
    }

    final before = sentence.substring(0, idx);
    final blank = '＿' * (answer.trim().length.clamp(3, 12));
    final after = sentence.substring(idx + answer.trim().length);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border:
            Border.all(color: scheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREVIEW',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          RichText(
            text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.6),
              children: [
                TextSpan(text: before),
                TextSpan(
                  text: blank,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: scheme.primary,
                    decorationThickness: 2,
                  ),
                ),
                TextSpan(text: after),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Match Madness editor ──────────────────────────────────────────

class _MatchEditor extends StatelessWidget {
  const _MatchEditor({
    required this.pairs,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdate,
  });

  final List<_Pair> pairs;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final void Function(int, _Pair) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Match Pairs',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            FilledButton.tonal(
              onPressed: onAdd,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  Text('Add Pair'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Each term will be matched to its corresponding answer',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        ...pairs.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _MatchRow(
                  index: e.key,
                  pair: e.value,
                  canRemove: pairs.length > 2,
                  onRemove: () => onRemove(e.key),
                  onChanged: (p) => onUpdate(e.key, p),
                ),
              ),
            ),
      ],
    );
  }
}

class _MatchRow extends HookWidget {
  const _MatchRow({
    required this.index,
    required this.pair,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  final int index;
  final _Pair pair;
  final bool canRemove;
  final VoidCallback onRemove;
  final void Function(_Pair) onChanged;

  @override
  Widget build(BuildContext context) {
    final termCtrl = useTextEditingController(text: pair.term);
    final matchCtrl = useTextEditingController(text: pair.match);
    useEffect(() {
      if (termCtrl.text != pair.term) {
        termCtrl.text = pair.term;
        termCtrl.selection =
            TextSelection.collapsed(offset: pair.term.length);
      }
      if (matchCtrl.text != pair.match) {
        matchCtrl.text = pair.match;
        matchCtrl.selection =
            TextSelection.collapsed(offset: pair.match.length);
      }
      return null;
    }, [pair.term, pair.match]);

    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: scheme.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              child: TextField(
                controller: termCtrl,
                decoration:
                    const InputDecoration(hintText: 'Term'),
                onChanged: (v) =>
                    onChanged((term: v, match: pair.match)),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.compare_arrows,
            color: scheme.primary.withValues(alpha: 0.5),
            size: 22,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
              child: TextField(
                controller: matchCtrl,
                decoration:
                    const InputDecoration(hintText: 'Match'),
                onChanged: (v) =>
                    onChanged((term: pair.term, match: v)),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onRemove,
              tooltip: 'Remove pair',
              color: AppColors.textSecondary,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}
