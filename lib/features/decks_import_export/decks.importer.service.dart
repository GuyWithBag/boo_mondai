import 'dart:convert';

import 'package:boo_mondai/core/helpers/csv.helper.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show Deck, JsonHelper, MapHelper, uuid, DeckImportResult, DeckMapNormalizer;
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

abstract class DecksImporterService {
  Future<DeckImportResult> importFromFileDecks() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return DeckImportResult.empty();

    var output = DeckImportResult.empty();
    for (final file in result.files) {
      final maps = await fileToMaps(file.xFile, file);
      for (final map in maps) {
        if (map['type']?.toString().toLowerCase() != 'deck') continue;
        output = output.merge(DeckMapNormalizer.flattenDeckMap(map));
      }
    }

    return output;
  }

  Future<DeckImportResult> importFromCardTemplateFiles(String deckTitle) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt', 'csv'],
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return DeckImportResult.empty();

    final deckId = uuid.v7();
    final now = DateTime.now();
    final deck = MapHelper.normalizeWithBaseMap(
      base: Deck.createDummy(id: deckId, title: deckTitle).toMap(),
      imported: {'title': deckTitle},
      injectValues: {
        'id': deckId,
        'title': deckTitle,
        'created_at': now,
        'updated_at': now,
      },
      requiredKeys: const {'title'},
    );
    final templates = <Map<String, dynamic>>[];
    final multipleChoiceOptions = <Map<String, dynamic>>[];
    final identificationAnswers = <Map<String, dynamic>>[];
    final fillInTheBlankSegments = <Map<String, dynamic>>[];
    final matchMadnessPairs = <Map<String, dynamic>>[];

    for (final file in result.files) {
      final maps = await fileToMaps(file.xFile, file);
      for (final map in maps) {
        final flattened = DeckMapNormalizer.flattenCardTemplateMap(
          map,
          deckId: deckId,
          sortOrder: templates.length,
        );
        templates.addAll(flattened.cardTemplates);
        multipleChoiceOptions.addAll(flattened.multipleChoiceOptions);
        identificationAnswers.addAll(flattened.identificationAnswers);
        fillInTheBlankSegments.addAll(flattened.fillInTheBlankSegments);
        matchMadnessPairs.addAll(flattened.matchMadnessPairs);
      }
    }

    return DeckImportResult(
      decks: [deck],
      cardTemplates: templates,
      multipleChoiceOptions: multipleChoiceOptions,
      identificationAnswers: identificationAnswers,
      fillInTheBlankSegments: fillInTheBlankSegments,
      matchMadnessPairs: matchMadnessPairs,
    );
  }

  Future<void> importFromDirectories() async {
    await FilePicker.getDirectoryPath();
  }

  Future<List<Map<String, dynamic>>> fileToMaps(
    XFile xFile,
    PlatformFile file,
  ) async {
    final text = await xFile.readAsString();
    final extension = file.extension?.trim().toLowerCase();

    if (extension == 'csv') {
      return CsvHelper.toManyMaps(text);
    }

    if (extension == 'json') {
      return JsonHelper.jsonDecodeToListMap(jsonDecode(text));
    }

    if (extension == 'txt' || extension == 'text') {
      if (JsonHelper.isTextJson(text)) {
        return JsonHelper.jsonDecodeToListMap(jsonDecode(text));
      }

      return CsvHelper.toManyMaps(text);
    }

    throw FormatException('Unsupported import file type: .$extension');
  }
}
