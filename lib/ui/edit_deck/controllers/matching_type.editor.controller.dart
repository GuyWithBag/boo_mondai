import 'package:boo_mondai/lib.barrel.dart'
    show
        MatchMadnessPair,
        MatchMadnessTemplate,
        MatchPairData,
        MatchPairHelper,
        defaultMatchPairs,
        uuid;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class MatchingTypeEditorController {
  MatchingTypeEditorController({
    required this.template,
    required this.onChanged,
  }) {
    verticallyCentered.value = template.verticallyCentered;
    pairs.value = template.pairs.isEmpty
        ? [...defaultMatchPairs]
        : [
            for (final pair in template.pairs)
              MatchPairData(term: pair.term, match: pair.match),
          ];
  }

  final MatchMadnessTemplate template;
  final ValueChanged<MatchMadnessTemplate> onChanged;

  final verticallyCentered = signal(true);
  final pairs = signal<List<MatchPairData>>(const []);

  void updateVerticallyCentered(bool value) {
    verticallyCentered.value = value;
    emit(verticallyCentered: value);
  }

  void addPair() {
    pairs.value = MatchPairHelper.add(pairs.value);
    emit();
  }

  void removePair(int index) {
    pairs.value = MatchPairHelper.removeAt(pairs.value, index);
    emit();
  }

  void updatePairTerm(int index, String term) {
    pairs.value = MatchPairHelper.updateTermAt(pairs.value, index, term);
    emit();
  }

  void updatePairMatch(int index, String match) {
    pairs.value = MatchPairHelper.updateMatchAt(pairs.value, index, match);
    emit();
  }

  void emit({bool? verticallyCentered}) {
    onChanged(
      MatchMadnessTemplate(
        id: template.id,
        deckId: template.deckId,
        sortOrder: template.sortOrder,
        createdAt: template.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: template.deletedAt,
        purgeAfter: template.purgeAfter,
        sourceTemplateId: template.sourceTemplateId,
        tags: template.tags,
        verticallyCentered: verticallyCentered ?? this.verticallyCentered.value,
        pairs: [
          for (final entry in pairs.value.asMap().entries)
            MatchMadnessPair(
              id: uuid.v7(),
              templateId: template.id,
              term: entry.value.term,
              match: entry.value.match,
              displayOrder: entry.key,
            ),
        ],
      ),
    );
  }

  void dispose() {
    verticallyCentered.dispose();
    pairs.dispose();
  }
}
