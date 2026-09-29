import 'dart:convert';

import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckMapNormalizer,
        DecksDirectoryPaths,
        DecksService,
        FileSystemHandler,
        JsonHelper,
        LocalDB,
        MapHelper,
        StudyCardService,
        uuid,
        DeckImportPreview,
        DeckImportResult,
        DeckImportUnsupportedKey,
        CardTemplate,
        DeckImportTitleConflict,
        DeckImportUnsupportedKeyReason,
        DeckImportMode,
        CsvHelper,
        Deck,
        DeckMapper,
        CardTemplateMapper,
        CasingHelper,
        FlashcardTemplate,
        IdentificationTemplate,
        MultipleChoiceTemplate,
        FillInTheBlanksTemplate,
        MatchingTypeTemplate,
        WordScrambleTemplate,
        MultipleChoiceOption,
        IdentificationAnswerKey,
        MatchingTypeValue;
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

final class DecksImporterService {
  const DecksImporterService();

  Future<DeckImportResult> importFromFileDecks() async {
    return (await previewDecksFromFiles()).result;
  }

  Future<DeckImportResult> importFromCardTemplateFiles(String deckTitle) async {
    return (await previewCardTemplatesFromFiles(deckTitle)).result;
  }

  Future<DeckImportPreview> previewDecksFromText(String text) async {
    return previewDeckMaps(textToMaps(text));
  }

  Future<DeckImportPreview> previewCardTemplatesFromText({
    required String text,
    required String deckTitle,
  }) async {
    return previewCardTemplateMaps(textToMaps(text), deckTitle: deckTitle);
  }

  Future<DeckImportPreview> previewDecksFromFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) {
      return DeckImportPreview.empty(DeckImportMode.decks);
    }

    final maps = <Map<String, dynamic>>[];
    for (final file in result.files) {
      maps.addAll(await fileToMaps(file.xFile, file));
    }

    return previewDeckMaps(maps);
  }

  Future<DeckImportPreview> previewCardTemplatesFromFiles(
    String deckTitle,
  ) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt', 'csv'],
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) {
      return DeckImportPreview.empty(DeckImportMode.cardTemplates);
    }

    final maps = <Map<String, dynamic>>[];
    for (final file in result.files) {
      maps.addAll(await fileToMaps(file.xFile, file));
    }

    return previewCardTemplateMaps(maps, deckTitle: deckTitle);
  }

  Future<void> importFromDirectories() async {
    await FilePicker.getDirectoryPath();
  }

  List<Map<String, dynamic>> textToMaps(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const [];

    if (JsonHelper.isTextJson(trimmed)) {
      return normalizeMany(JsonHelper.jsonDecodeToListMap(jsonDecode(trimmed)));
    }

    return normalizeMany(CsvHelper.toManyMaps(trimmed));
  }

  Future<List<Map<String, dynamic>>> fileToMaps(
    XFile xFile,
    PlatformFile file,
  ) async {
    final text = await xFile.readAsString();
    final extension = file.extension?.trim().toLowerCase();

    if (extension == 'csv') {
      return normalizeMany(CsvHelper.toManyMaps(text));
    }

    if (extension == 'json') {
      return normalizeMany(JsonHelper.jsonDecodeToListMap(jsonDecode(text)));
    }

    if (extension == 'txt' || extension == 'text') {
      return textToMaps(text);
    }

    throw FormatException('Unsupported import file type: .$extension');
  }

  Future<DeckImportPreview> previewDeckMaps(
    List<Map<String, dynamic>> maps,
  ) async {
    var result = DeckImportResult.empty();
    final unsupportedKeys = <DeckImportUnsupportedKey>[];

    for (final entry in maps.asMap().entries) {
      final map = entry.value;
      if (normalizedType(map) != 'deck') continue;

      unsupportedKeys.addAll(unsupportedDeckKeys(map, 'decks[${entry.key}]'));
      result = result.merge(DeckMapNormalizer.flattenDeckMap(map));
    }

    return DeckImportPreview(
      mode: DeckImportMode.decks,
      result: result,
      titleConflicts: await titleConflicts(result),
      unsupportedKeys: unsupportedKeys,
    );
  }

  Future<DeckImportPreview> previewCardTemplateMaps(
    List<Map<String, dynamic>> maps, {
    required String deckTitle,
  }) async {
    final trimmedTitle = deckTitle.trim();
    if (trimmedTitle.isEmpty) {
      throw const FormatException(
        'Card template import requires a deck title.',
      );
    }

    final deckId = uuid.v7();
    final now = DateTime.now();
    final deck = MapHelper.normalizeWithBaseMap(
      base: Deck.createDummy(id: deckId, title: trimmedTitle).toMap(),
      imported: {'title': trimmedTitle},
      injectValues: {
        'id': deckId,
        'title': trimmedTitle,
        'created_at': now,
        'updated_at': now,
      },
      requiredKeys: const {'title'},
    );

    var result = DeckImportResult(decks: [deck]);
    final unsupportedKeys = <DeckImportUnsupportedKey>[];

    for (final entry in maps.asMap().entries) {
      final map = entry.value;
      unsupportedKeys.addAll(
        unsupportedTemplateKeys(map, 'templates[${entry.key}]'),
      );
      result = result.merge(
        DeckMapNormalizer.flattenCardTemplateMap(
          map,
          deckId: deckId,
          sortOrder: entry.key,
        ),
      );
    }

    return DeckImportPreview(
      mode: DeckImportMode.cardTemplates,
      result: result,
      titleConflicts: await titleConflicts(result),
      unsupportedKeys: unsupportedKeys,
    );
  }

  Future<void> commitPreview(DeckImportPreview preview) async {
    final profileId = LocalDB.currentProfile.getOrCreate().id;
    final templates = templatesFromResult(preview.result);
    final templateCountByDeckId = <String, int>{};
    for (final template in templates) {
      templateCountByDeckId.update(
        template.deckId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final decks = [
      for (final map in preview.result.decks)
        DeckMapper.fromMap({
          ...map,
          'profile_id': profileId,
          'card_templates_count': templateCountByDeckId[map['id']] ?? 0,
        }),
    ];

    await LocalDB.deck.upsertMany(decks);
    await LocalDB.cardTemplate.upsertMany(templates);

    for (final deck in decks) {
      await StudyCardService.syncDeckStudyCards(
        deckId: deck.id,
        templates: templates
            .where((template) => template.deckId == deck.id)
            .toList(growable: false),
      );
    }
  }

  List<CardTemplate> templatesFromResult(DeckImportResult result) {
    final optionsByTemplateId = groupByParentId(
      result.multipleChoiceOptions,
      'template_id',
    );
    final answersByTemplateId = groupByParentId(
      result.identificationAnswers,
      'template_id',
    );
    final pairsByTemplateId = groupByParentId(
      result.matchMadnessPairs,
      'template_id',
    );

    return [
      for (final template in result.cardTemplates)
        CardTemplateMapper.fromMap(
          withTemplateChildren(
            template,
            optionsByTemplateId: optionsByTemplateId,
            answersByTemplateId: answersByTemplateId,
            pairsByTemplateId: pairsByTemplateId,
          ),
        ),
    ];
  }

  Map<String, dynamic> withTemplateChildren(
    Map<String, dynamic> template, {
    required Map<String, List<Map<String, dynamic>>> optionsByTemplateId,
    required Map<String, List<Map<String, dynamic>>> answersByTemplateId,
    required Map<String, List<Map<String, dynamic>>> pairsByTemplateId,
  }) {
    final templateId = template['id']?.toString();
    if (templateId == null) return template;

    return switch (template['type']?.toString()) {
      'multiple_choice' => {
        ...template,
        'options': optionsByTemplateId[templateId] ?? const [],
      },
      'identification' => {
        ...template,
        'accepted_answers': answersByTemplateId[templateId] ?? const [],
      },
      'fill_in_the_blanks' => {...template},
      'match_madness' => {
        ...template,
        'pairs': pairsByTemplateId[templateId] ?? const [],
      },
      _ => template,
    };
  }

  Map<String, List<Map<String, dynamic>>> groupByParentId(
    List<Map<String, dynamic>> maps,
    String parentKey,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final map in maps) {
      final parentId = map[parentKey]?.toString();
      if (parentId == null || parentId.isEmpty) continue;
      grouped.putIfAbsent(parentId, () => []).add(map);
    }
    return grouped;
  }

  Future<List<DeckImportTitleConflict>> titleConflicts(
    DeckImportResult result,
  ) async {
    final conflicts = <DeckImportTitleConflict>[];
    final reservedTitles = LocalDB.deck
        .selectMany()
        .map((deck) => deck.title.trim().toLowerCase())
        .toSet();

    for (final entry in result.decks.asMap().entries) {
      final title = entry.value['title']?.toString().trim() ?? '';
      if (title.isEmpty) continue;

      final directoryExists =
          await FileSystemHandler.doesDirectoryExistRelatively(
            DecksDirectoryPaths.root(deckTitle: title),
          );

      if (reservedTitles.contains(title.toLowerCase()) || directoryExists) {
        final suggestedTitle = await nextAvailableTitle(
          baseTitle: title,
          reservedTitles: reservedTitles,
        );
        conflicts.add(
          DeckImportTitleConflict(
            deckIndex: entry.key,
            title: title,
            suggestedTitle: suggestedTitle,
          ),
        );
        reservedTitles.add(suggestedTitle.toLowerCase());
      } else {
        reservedTitles.add(title.toLowerCase());
      }
    }

    return conflicts;
  }

  Future<String> nextAvailableTitle({
    required String baseTitle,
    required Set<String> reservedTitles,
  }) async {
    var candidate = await DecksService.nextDeckTitle(baseTitle: baseTitle);
    var index = 1;

    while (reservedTitles.contains(candidate.toLowerCase())) {
      candidate = '$baseTitle ${++index}';
      final directoryExists =
          await FileSystemHandler.doesDirectoryExistRelatively(
            DecksDirectoryPaths.root(deckTitle: candidate),
          );
      if (!reservedTitles.contains(candidate.toLowerCase()) &&
          !directoryExists) {
        break;
      }
    }

    return candidate;
  }

  List<DeckImportUnsupportedKey> unsupportedDeckKeys(
    Map<String, dynamic> map,
    String path,
  ) {
    final unsupported = unsupportedKeys(
      map,
      path,
      allowedKeys: deckAllowedKeys,
    );
    final templates = map['templates'];
    if (templates is List) {
      for (final entry in templates.asMap().entries) {
        final template = entry.value;
        if (template is Map<String, dynamic>) {
          unsupported.addAll(
            unsupportedTemplateKeys(template, '$path.templates[${entry.key}]'),
          );
        }
      }
    }
    return unsupported;
  }

  List<DeckImportUnsupportedKey> unsupportedTemplateKeys(
    Map<String, dynamic> map,
    String path,
  ) {
    final unsupported = unsupportedKeys(
      map,
      path,
      allowedKeys: templateAllowedKeys(map),
    );

    for (final child in templateChildKeys.entries) {
      final values = map[child.key];
      if (values is! List) continue;

      for (final entry in values.asMap().entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          unsupported.addAll(
            unsupportedKeys(
              value,
              '$path.${child.key}[${entry.key}]',
              allowedKeys: child.value,
            ),
          );
        }
      }
    }

    return unsupported;
  }

  List<DeckImportUnsupportedKey> unsupportedKeys(
    Map<String, dynamic> map,
    String path, {
    required Set<String> allowedKeys,
  }) {
    return [
      for (final entry in map.entries)
        if (unsupportedReason(entry.key, allowedKeys) != null)
          DeckImportUnsupportedKey(
            path: '$path.${entry.key}',
            key: entry.key,
            reason: unsupportedReason(entry.key, allowedKeys)!,
          ),
    ];
  }

  DeckImportUnsupportedKeyReason? unsupportedReason(
    String key,
    Set<String> allowedKeys,
  ) {
    final normalizedKey = CasingHelper.toSnakeCase(key);
    if (generatedKeys.contains(normalizedKey) ||
        MapHelper.isKeyId(normalizedKey)) {
      return DeckImportUnsupportedKeyReason.generated;
    }

    if (joinedKeys.contains(normalizedKey)) {
      return DeckImportUnsupportedKeyReason.joined;
    }

    if (!allowedKeys.contains(normalizedKey)) {
      return DeckImportUnsupportedKeyReason.unsupported;
    }

    return null;
  }

  Set<String> templateAllowedKeys(Map<String, dynamic> map) {
    return switch (normalizedType(map)) {
      'flashcard' => keysWithType(FlashcardTemplate.createDummy().toMap()),
      'identification' => keysWithType(
        IdentificationTemplate.createDummy().toMap(),
      ),
      'multiple_choice' => keysWithType(
        MultipleChoiceTemplate.createDummy().toMap(),
      ),
      'fill_in_the_blanks' => keysWithType(
        FillInTheBlanksTemplate.createDummy().toMap(),
      ),
      'match_madness' => keysWithType(
        MatchingTypeTemplate.createDummy().toMap(),
      ),
      'word_scramble' => keysWithType(
        WordScrambleTemplate.createDummy().toMap(),
      ),
      _ => commonTemplateAllowedKeys,
    };
  }

  Set<String> keysWithType(Map<String, dynamic> map) => {...map.keys, 'type'};

  String? normalizedType(Map<String, dynamic> map) {
    final value = map['type']?.toString();
    if (value == null || value.trim().isEmpty) return null;
    return CasingHelper.toSnakeCase(value);
  }

  List<Map<String, dynamic>> normalizeMany(List<Map<String, dynamic>> maps) {
    return [
      for (final map in maps)
        Map<String, dynamic>.from(normalizeKeysToSnakeCase(map) as Map),
    ];
  }

  Object? normalizeKeysToSnakeCase(Object? value) {
    return switch (value) {
      final Map<dynamic, dynamic> map => {
        for (final entry in map.entries)
          CasingHelper.toSnakeCase(entry.key.toString()):
              normalizeKeysToSnakeCase(entry.value),
      },
      final List<dynamic> list => [
        for (final item in list) normalizeKeysToSnakeCase(item),
      ],
      _ => value,
    };
  }

  Set<String> get deckAllowedKeys => {
    ...Deck.createDummy().toMap().keys,
    'type',
    'templates',
  };

  Set<String> get commonTemplateAllowedKeys => {
    ...keysWithType(FlashcardTemplate.createDummy().toMap()),
    ...keysWithType(IdentificationTemplate.createDummy().toMap()),
    ...keysWithType(MultipleChoiceTemplate.createDummy().toMap()),
    ...keysWithType(FillInTheBlanksTemplate.createDummy().toMap()),
    ...keysWithType(MatchingTypeTemplate.createDummy().toMap()),
    ...keysWithType(WordScrambleTemplate.createDummy().toMap()),
  };

  Map<String, Set<String>> get templateChildKeys => {
    'options': MultipleChoiceOption.createDummy().toMap().keys.toSet(),
    'accepted_answers': IdentificationAnswerKey.createDummy()
        .toMap()
        .keys
        .toSet(),
    'pairs': MatchingTypeValue.createDummy().toMap().keys.toSet(),
  };

  Set<String> get generatedKeys => const {
    'id',
    'created_at',
    'updated_at',
    'deleted_at',
    'purge_after',
    'profile_id',
    'deck_id',
    'template_id',
    'card_id',
    'source_deck_id',
    'source_template_id',
    'sort_order',
    'display_order',
  };

  Set<String> get joinedKeys => const {
    'deck',
    'template',
    'listing',
    'deck_listing',
    'profile',
    'source_profile',
    'content',
    'deck_listing_content',
    'study_card',
    'study_cards',
  };
}
