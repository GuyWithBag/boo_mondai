import 'package:boo_mondai/features/decks_import_export/models/deck_import.mode.dart';
import 'package:boo_mondai/features/decks_import_export/models/deck_import.result.dart';
import 'package:boo_mondai/features/decks_import_export/models/deck_import_title_conflict.dart';
import 'package:boo_mondai/features/decks_import_export/models/deck_import_unsupported_key.dart';

final class DeckImportPreview {
  const DeckImportPreview({
    required this.mode,
    required this.result,
    this.titleConflicts = const [],
    this.unsupportedKeys = const [],
  });

  factory DeckImportPreview.empty(DeckImportMode mode) {
    return DeckImportPreview(mode: mode, result: DeckImportResult.empty());
  }

  final DeckImportMode mode;
  final DeckImportResult result;
  final List<DeckImportTitleConflict> titleConflicts;
  final List<DeckImportUnsupportedKey> unsupportedKeys;

  bool get hasChanges =>
      result.decks.isNotEmpty ||
      result.cardTemplates.isNotEmpty ||
      result.multipleChoiceOptions.isNotEmpty ||
      result.identificationAnswers.isNotEmpty ||
      result.matchMadnessPairs.isNotEmpty;

  bool get hasTitleConflicts => titleConflicts.isNotEmpty;
  bool get hasUnsupportedKeys => unsupportedKeys.isNotEmpty;

  DeckImportPreview resolveTitleConflicts(Map<int, String> titlesByDeckIndex) {
    final decks = [
      for (var index = 0; index < result.decks.length; index++)
        if (titlesByDeckIndex[index]?.trim().isNotEmpty ?? false)
          {...result.decks[index], 'title': titlesByDeckIndex[index]!.trim()}
        else
          result.decks[index],
    ];

    return DeckImportPreview(
      mode: mode,
      result: DeckImportResult(
        decks: decks,
        cardTemplates: result.cardTemplates,
        multipleChoiceOptions: result.multipleChoiceOptions,
        identificationAnswers: result.identificationAnswers,
        matchMadnessPairs: result.matchMadnessPairs,
      ),
      titleConflicts: [
        for (final conflict in titleConflicts)
          if (!titlesByDeckIndex.containsKey(conflict.deckIndex)) conflict,
      ],
      unsupportedKeys: unsupportedKeys,
    );
  }
}
