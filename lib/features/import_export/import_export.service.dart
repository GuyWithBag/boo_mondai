import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:boo_mondai/features/card_attachments/helpers/attachment_label.helper.dart';
import 'package:boo_mondai/features/card_attachments/helpers/mime.helper.dart';
import 'package:boo_mondai/features/card_attachments/media_storage.service.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        CardTemplateMapper,
        CardAttachment,
        CardLinkAttachment,
        CardMediaAttachment,
        Deck,
        DeckMapper,
        DeckImportMode,
        FillInTheBlanksTemplate,
        FillInTheBlankSegment,
        FlashcardTemplate,
        IdentificationTemplate,
        ImportCardMatchCandidate,
        ChangePlan,
        ImportCardsPayload,
        ImportExportBackup,
        LocalImageCacheKeysHelper,
        LocalImageCacheService,
        LocalImagePathHelper,
        LocalImageResolverHelper,
        ChangeBatchResult,
        ChangedEntity,
        ChangeDifferenceHelper,
        ChangeSource,
        ChangeType,
        ChangeResult,
        LocalDB,
        MatchMadnessPair,
        MatchMadnessTemplate,
        MultipleChoiceOption,
        MultipleChoiceTemplate,
        CardImportAction,
        CardImportDecision,
        CardSimilarityConfig,
        StudyCardService,
        WordScrambleTemplate,
        uuid;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

enum ImportMatchStrategy { byId, byFrontText, byFrontAndBackText }

enum ImportConflictStrategy { skip, overwrite, keepNewer }

class ImportOptions {
  final ImportMatchStrategy matchStrategy;
  final ImportConflictStrategy conflictStrategy;

  const ImportOptions({
    this.matchStrategy = ImportMatchStrategy.byId,
    this.conflictStrategy = ImportConflictStrategy.overwrite,
  });
}

sealed class ImportResult {
  const ImportResult();
}

class ImportSuccess extends ImportResult {
  final String deckId;

  const ImportSuccess(this.deckId);
}

class ImportFailure extends ImportResult {
  final String reason;

  const ImportFailure(this.reason);
}

/// Static import/export operations for decks and card templates.
class ImportExportService {
  const ImportExportService._();

  /// Exports one deck with templates, tags, and media URL references.
  static Future<ChangeResult<Map<String, dynamic>, Object?>> exportDeck(
    String deckId,
  ) async {
    final deck = LocalDB.deck.selectByPk({'id': deckId});
    if (deck == null) {
      throw Exception('Deck not found: $deckId');
    }
    final templates = LocalDB.cardTemplate.getByDeckId(deckId);
    final payload = _buildDeckPayload(deck: deck, templates: templates);
    final logs = <ChangedEntity<Object?>>[
      ChangedEntity<Object?>(
        type: ChangeType.added,
        source: ChangeSource.importExport,
        entityType: 'deck',
        entityId: deck.id,
        title: 'Exported ${deck.title}',
        subtitle: '${templates.length} cards',
        afterChange: deck,
      ),
    ];
    await _storeBackup(
      operation: 'export_deck',
      entityType: 'deck',
      entityId: deck.id,
      title: 'Export deck ${deck.title}',
      payload: payload,
      logs: logs,
    );
    return ChangeResult(value: payload, changes: logs);
  }

  /// Exports multiple decks and returns per-deck partial failures.
  static Future<ChangeBatchResult<Map<String, dynamic>>> exportDecks(
    List<String> deckIds,
  ) async {
    final values = <Map<String, dynamic>>[];
    final failures = <String>[];
    final logs = <ChangedEntity>[];

    for (final deckId in deckIds) {
      try {
        final result = await exportDeck(deckId);
        values.add(result.value);
        logs.addAll(result.changes);
      } on Exception catch (e) {
        failures.add('Deck $deckId: $e');
      }
    }

    return ChangeBatchResult(values: values, failures: failures, changes: logs);
  }

  static Future<File> exportDeckBundle(String deckId) async {
    final deck = LocalDB.deck.selectByPk({'id': deckId});
    if (deck == null) {
      throw Exception('Deck not found: $deckId');
    }

    final templates = LocalDB.cardTemplate.getByDeckId(deckId);
    final archive = Archive();
    final templateEntries = <Map<String, dynamic>>[];
    final deckMap = Map<String, dynamic>.from(deck.toMap());

    final coverImageSource = LocalImageResolverHelper.resolveDeckCover(deck);
    final coverImageBytes = await _resolveImageBytes(coverImageSource);
    if (coverImageBytes == null) {
      deckMap['cover_image_content_path'] = null;
      deckMap['cover_image_byte_size'] = null;
    } else {
      const coverImageContentPath = 'media/deck-cover.png';
      deckMap['cover_image_content_path'] = coverImageContentPath;
      deckMap['cover_image_byte_size'] = coverImageBytes.length;
      archive.addFile(
        ArchiveFile.bytes(coverImageContentPath, coverImageBytes),
      );
    }

    final featuredImageContentPaths = <String?>[];
    final featuredImages = deck.listing?.featuredImages ?? const <String>[];
    for (var index = 0; index < featuredImages.length; index++) {
      final imageSource =
          LocalImageResolverHelper.resolveDeckListingFeaturedImage(
            deck: deck,
            index: index,
          );
      final imageBytes = await _resolveImageBytes(imageSource);
      if (imageBytes == null) {
        featuredImageContentPaths.add(null);
        continue;
      }
      final contentPath = 'media/featured-image-$index.png';
      featuredImageContentPaths.add(contentPath);
      archive.addFile(ArchiveFile.bytes(contentPath, imageBytes));
    }
    deckMap['deck_listing_featured_image_content_paths'] =
        featuredImageContentPaths;

    for (final template in templates) {
      final templateMap = Map<String, dynamic>.from(template.toMap());
      final attachmentEntries = <Map<String, dynamic>>[];
      for (final attachment in template.attachments) {
        switch (attachment) {
          case CardMediaAttachment a:
            final extension = MimeHelper.extensionFromMimeType(a.mimeType);
            final contentPath = 'media/${a.id}.$extension';
            final bytes = await _resolveMediaBytes(a);
            attachmentEntries.add({
              'attachment_source': 'media',
              'id': a.id,
              'template_id': a.templateId,
              'type': a.type.name,
              'label': a.label,
              'storage_path': a.storagePath,
              'public_url': a.publicUrl,
              'mime_type': a.mimeType,
              'alt_text': a.altText,
              'created_at': a.createdAt.toIso8601String(),
              'content_path': bytes == null ? null : contentPath,
              'byte_size': bytes?.length,
            });
            if (bytes == null) {
              developer.log(
                'Skipped missing media attachment ${a.id}',
                name: 'ImportExportService',
              );
            } else {
              archive.addFile(ArchiveFile.bytes(contentPath, bytes));
            }
          case CardLinkAttachment a:
            attachmentEntries.add({
              'attachment_source': 'link',
              'id': a.id,
              'template_id': a.templateId,
              'type': a.type.name,
              'label': a.label,
              'url': a.url,
              'alt_text': a.altText,
              'created_at': a.createdAt.toIso8601String(),
            });
        }
      }
      templateMap['attachments'] = attachmentEntries;
      templateEntries.add(templateMap);
    }

    final manifest = {
      'format': 'boo_mondai_deck_bundle_v1',
      'exported_at': DateTime.now().toIso8601String(),
      'source_user_id': LocalDB.profile.getOrCreate().id,
      'deck': deckMap,
      'card_templates': templateEntries,
    };
    archive.addFile(ArchiveFile.string('manifest.json', jsonEncode(manifest)));

    final cache = await getTemporaryDirectory();
    final fileName = '${_safeBundleFileName(deck.title)}.boomondai.zip';
    final file = File('${cache.path}/$fileName');
    final bytes = ZipEncoder().encodeBytes(archive);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<ImportResult> importDeckBundle(
    File bundleFile,
    ImportOptions options,
  ) async {
    Directory? tempDir;
    try {
      if (!bundleFile.path.endsWith('.zip') &&
          !bundleFile.path.endsWith('.boomondai.zip')) {
        return const ImportFailure('Expected a .zip or .boomondai.zip file.');
      }

      tempDir = await Directory.systemTemp.createTemp('boo_mondai_bundle_');
      final archive = ZipDecoder().decodeBytes(await bundleFile.readAsBytes());
      final manifestFile = archive.findFile('manifest.json');
      if (manifestFile == null) {
        return const ImportFailure('Bundle is missing manifest.json.');
      }

      final manifest = jsonDecode(utf8.decode(manifestFile.content));
      if (manifest is! Map<String, dynamic> ||
          manifest['format'] != 'boo_mondai_deck_bundle_v1') {
        return const ImportFailure('Unsupported bundle format.');
      }

      for (final file in archive.files) {
        if (!file.isFile || file.name == 'manifest.json') continue;
        final output = File('${tempDir.path}/${file.name}');
        await output.parent.create(recursive: true);
        await output.writeAsBytes(file.content);
      }

      final currentUserId = LocalDB.profile.getOrCreate().id;
      final ownBackup = manifest['source_user_id'] == currentUserId;
      final deckMap = Map<String, dynamic>.from(manifest['deck'] as Map);
      final coverImageContentPath =
          deckMap.remove('cover_image_content_path') as String?;
      deckMap.remove('cover_image_byte_size');
      final featuredImageContentPaths =
          (deckMap.remove('deck_listing_featured_image_content_paths')
                      as List? ??
                  const [])
              .map((value) => value?.toString())
              .toList(growable: false);
      final incomingDeck = DeckMapper.fromMap(deckMap);
      final matchingDeck = _findMatchingDeck(incomingDeck);
      if (matchingDeck != null) {
        if (options.conflictStrategy == ImportConflictStrategy.skip) {
          return ImportSuccess(matchingDeck.id);
        }
        if (options.conflictStrategy == ImportConflictStrategy.keepNewer &&
            !incomingDeck.updatedAt.isAfter(matchingDeck.updatedAt)) {
          return ImportSuccess(matchingDeck.id);
        }
      }

      final targetDeckId = ownBackup
          ? incomingDeck.id
          : matchingDeck?.id ?? uuid.v7();
      final templateMaps = _extractTemplateMaps(manifest);
      final templateIdMap = {
        for (final map in templateMaps)
          (map['id'] as String): ownBackup ? map['id'] as String : uuid.v7(),
      };
      final attachmentIdMap = {
        for (final template in templateMaps)
          for (final raw in (template['attachments'] as List? ?? const []))
            if (raw is Map)
              (raw['id'] as String): ownBackup
                  ? raw['id'] as String
                  : uuid.v7(),
      };

      final rewrittenTemplateMaps = <Map<String, dynamic>>[];
      final labels = <String>[];
      for (final templateMap in templateMaps) {
        final oldTemplateId = templateMap['id'] as String;
        final rewritten = Map<String, dynamic>.from(templateMap)
          ..['id'] = templateIdMap[oldTemplateId]
          ..['deck_id'] = targetDeckId;
        final attachments = <Map<String, dynamic>>[];
        for (final raw in (templateMap['attachments'] as List? ?? const [])) {
          if (raw is! Map) continue;
          final attachment = Map<String, dynamic>.from(raw);
          final sanitized = AttachmentLabelHelper.sanitizeLabel(
            (attachment['label'] ?? '').toString(),
          );
          final label =
              AttachmentLabelHelper.validateAttachmentLabel(
                    sanitized,
                    labels,
                  ) ==
                  null
              ? sanitized
              : AttachmentLabelHelper.generateFallbackLabel(labels);
          labels.add(label);
          attachment
            ..['id'] = attachmentIdMap[raw['id']]
            ..['template_id'] = templateIdMap[oldTemplateId]
            ..['label'] = label
            ..['type'] ??= raw['kind'];

          if (attachment['attachment_source'] == 'media' &&
              attachment['content_path'] != null) {
            final mediaFile = File(
              '${tempDir.path}/${attachment['content_path']}',
            );
            if (await mediaFile.exists()) {
              attachment['localPath'] =
                  await MediaStorageService.saveMediaLocally(
                    attachmentId: attachment['id'] as String,
                    bytes: await mediaFile.readAsBytes(),
                    mimeType: attachment['mime_type'] as String,
                  );
            }
          }
          attachments.add(attachment);
        }
        rewritten['attachments'] = attachments;
        rewrittenTemplateMaps.add(rewritten);
      }

      var deck = incomingDeck.copyWith(
        id: targetDeckId,
        userId: currentUserId,
        isPublished: false,
        isEditable: true,
        userProfile: null,
        listing: null,
        sourceDeckId: ownBackup
            ? incomingDeck.sourceDeckId
            : incomingDeck.sourceDeckId ?? incomingDeck.id,
      );
      await _restoreBundledImage(
        tempDir: tempDir,
        contentPath: coverImageContentPath,
        cacheKey: LocalImageCacheKeysHelper.deckCover(deck.id),
        remotePath: _remotePathOrNull(incomingDeck.coverImageUrl),
      );

      final listing = incomingDeck.listing;
      if (listing != null) {
        final featuredImages = listing.featuredImages.toList();
        for (var index = 0; index < featuredImageContentPaths.length; index++) {
          final localPath = await _restoreBundledImage(
            tempDir: tempDir,
            contentPath: featuredImageContentPaths[index],
            cacheKey: LocalImageCacheKeysHelper.deckListingFeaturedImage(
              deck.id,
              index,
            ),
            remotePath: index < listing.featuredImages.length
                ? _remotePathOrNull(listing.featuredImages[index])
                : null,
          );
          if (localPath == null) continue;
          if (index < featuredImages.length) {
            featuredImages[index] =
                _remotePathOrNull(featuredImages[index]) ?? '';
          } else {
            while (featuredImages.length < index) {
              featuredImages.add('');
            }
            featuredImages.add('');
          }
        }
        final updatedListing = listing.copyWith(
          deckId: deck.id,
          featuredImages: featuredImages,
        );
        await LocalDB.deckListing.upsert(updatedListing);
        deck = deck.copyWith(listing: updatedListing);
      }
      final templates = _decodeTemplates(rewrittenTemplateMaps);
      await LocalDB.deck.upsert(deck);
      await LocalDB.cardTemplate.upsertMany(templates);
      await StudyCardService.syncDeckStudyCards(
        deckId: deck.id,
        templates: templates,
      );

      return ImportSuccess(deck.id);
    } on Exception catch (e) {
      return ImportFailure(e.toString());
    } finally {
      if (tempDir != null && await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  }

  /// Exports cards from one deck, optionally scoped to [templateIds].
  static Future<ChangeResult<Map<String, dynamic>, CardTemplate>> exportCards({
    required String deckId,
    List<String>? templateIds,
  }) async {
    final deck = LocalDB.deck.selectByPk({'id': deckId});
    if (deck == null) {
      throw Exception('Deck not found: $deckId');
    }

    final deckTemplates = LocalDB.cardTemplate.getByDeckId(deckId);
    final selected = templateIds == null
        ? deckTemplates
        : deckTemplates
              .where((template) => templateIds.contains(template.id))
              .toList(growable: false);

    final payload = <String, dynamic>{
      'format': 'boo_mondai_cards_v1',
      'deck': {'id': deck.id, 'title': deck.title},
      'exported_at': DateTime.now().toIso8601String(),
      'card_templates': [for (final template in selected) template.toMap()],
    };

    final logs = <ChangedEntity<CardTemplate>>[
      ChangedEntity<CardTemplate>(
        type: ChangeType.added,
        source: ChangeSource.importExport,
        entityType: 'card_templates',
        entityId: deckId,
        title: 'Exported cards from ${deck.title}',
        subtitle: '${selected.length} cards',
      ),
    ];

    await _storeBackup(
      operation: 'export_cards',
      entityType: 'card_templates',
      entityId: deckId,
      title: 'Export cards from ${deck.title}',
      payload: payload,
      logs: logs,
    );

    return ChangeResult(value: payload, changes: logs);
  }

  /// Imports one deck payload using [mode] and optional [targetDeckId].
  static Future<ChangeResult<Deck?, Object?>> importDeck({
    required Map<String, dynamic> payload,
    DeckImportMode mode = DeckImportMode.createNew,
    String? targetDeckId,
  }) async {
    final deckMap = Map<String, dynamic>.from(
      payload['deck'] as Map<String, dynamic>,
    );
    final incomingDeck = DeckMapper.fromMap(deckMap);
    final incomingTemplateMaps = _extractTemplateMaps(payload);
    final incomingTemplates = _decodeTemplates(incomingTemplateMaps);
    final logs = <ChangedEntity<Object?>>[];

    if (mode == DeckImportMode.skip) {
      logs.add(
        ChangedEntity(
          type: ChangeType.skipped,
          source: ChangeSource.importExport,
          entityType: 'deck',
          entityId: incomingDeck.id,
          title: 'Skipped ${incomingDeck.title}',
          afterChange: incomingDeck,
        ),
      );
      return ChangeResult(value: null, changes: logs);
    }

    if (mode == DeckImportMode.updateExisting) {
      if (targetDeckId == null) {
        throw Exception('targetDeckId is required for updateExisting mode.');
      }
      final target = LocalDB.deck.selectByPk({'id': targetDeckId});
      if (target == null) {
        throw Exception('Target deck not found: $targetDeckId');
      }

      final now = DateTime.now();
      final updatedDeck = target.copyWith(
        title: incomingDeck.title,
        shortDescription: incomingDeck.shortDescription,
        longDescription: incomingDeck.longDescription,
        coverImageUrl: incomingDeck.coverImageUrl,
        tags: incomingDeck.tags,
        updatedAt: now,
        buildNumber: target.buildNumber + 1,
      );
      await LocalDB.deck.upsert(updatedDeck);

      final copiedTemplates = _copyTemplatesForDeck(
        templates: incomingTemplates,
        deckId: target.id,
      );
      await LocalDB.cardTemplate.upsertMany(copiedTemplates);
      await StudyCardService.syncDeckStudyCards(
        deckId: target.id,
        templates: LocalDB.cardTemplate.getByDeckId(target.id),
      );

      logs.add(
        ChangedEntity(
          type: ChangeType.modified,
          source: ChangeSource.importExport,
          entityType: 'deck',
          entityId: target.id,
          title: 'Updated ${target.title}',
          subtitle: '${copiedTemplates.length} imported cards',
          beforeChange: target,
          afterChange: updatedDeck,
          changedProperties: ChangeDifferenceHelper.decks(target, updatedDeck),
        ),
      );

      await _storeBackup(
        operation: 'import_deck',
        entityType: 'deck',
        entityId: target.id,
        title: 'Import deck update ${updatedDeck.title}',
        payload: payload,
        logs: logs,
      );

      return ChangeResult(value: updatedDeck, changes: logs);
    }

    final profile = LocalDB.profile.getOrCreate();
    final now = DateTime.now();
    final createdDeck = incomingDeck.copyWith(
      id: uuid.v7(),
      userId: profile.id,
      createdAt: now,
      updatedAt: now,
      isPublished: false,
      isEditable: true,
      visibilityState: incomingDeck.visibilityState,
      userProfile: null,
      listing: null,
      sourceDeckId: incomingDeck.sourceDeckId ?? incomingDeck.id,
    );
    final copiedTemplates = _copyTemplatesForDeck(
      templates: incomingTemplates,
      deckId: createdDeck.id,
    );
    await LocalDB.deck.upsert(createdDeck);
    await LocalDB.cardTemplate.upsertMany(copiedTemplates);
    await StudyCardService.syncDeckStudyCards(
      deckId: createdDeck.id,
      templates: copiedTemplates,
    );

    logs.add(
      ChangedEntity(
        type: ChangeType.added,
        source: ChangeSource.importExport,
        entityType: 'deck',
        entityId: createdDeck.id,
        title: createdDeck.title,
        subtitle: '${copiedTemplates.length} imported cards',
        afterChange: createdDeck,
      ),
    );

    await _storeBackup(
      operation: 'import_deck',
      entityType: 'deck',
      entityId: createdDeck.id,
      title: 'Import new deck ${createdDeck.title}',
      payload: payload,
      logs: logs,
    );

    return ChangeResult(value: createdDeck, changes: logs);
  }

  /// Imports one deck from raw JSON.
  static Future<ChangeResult<Deck?, Object?>> importDeckJson({
    required String rawJson,
    DeckImportMode mode = DeckImportMode.createNew,
    String? targetDeckId,
  }) async {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Expected deck JSON object.');
    }
    return importDeck(payload: decoded, mode: mode, targetDeckId: targetDeckId);
  }

  /// Imports multiple deck payloads with partial success.
  static Future<ChangeBatchResult<Deck?>> importDecks({
    required List<Map<String, dynamic>> payloads,
    DeckImportMode mode = DeckImportMode.createNew,
    Map<int, String> updateTargetsByIndex = const {},
  }) async {
    final values = <Deck?>[];
    final failures = <String>[];
    final logs = <ChangedEntity>[];

    for (var i = 0; i < payloads.length; i++) {
      try {
        final result = await importDeck(
          payload: payloads[i],
          mode: mode,
          targetDeckId: updateTargetsByIndex[i],
        );
        values.add(result.value);
        logs.addAll(result.changes);
      } on Exception catch (e) {
        failures.add('Index $i: $e');
      }
    }

    return ChangeBatchResult(values: values, failures: failures, changes: logs);
  }

  /// Imports multiple decks from raw JSON. Accepts either `{decks:[...]}` or `[...]`.
  static Future<ChangeBatchResult<Deck?>> importDecksJson({
    required String rawJson,
    DeckImportMode mode = DeckImportMode.createNew,
    Map<int, String> updateTargetsByIndex = const {},
  }) async {
    final decoded = jsonDecode(rawJson);
    final payloads = switch (decoded) {
      List _ =>
        decoded
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false),
      Map _ =>
        ((decoded as Map<String, dynamic>)['decks'] as List<dynamic>)
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false),
      _ => throw Exception('Expected JSON array or object containing "decks".'),
    };

    return importDecks(
      payloads: payloads,
      mode: mode,
      updateTargetsByIndex: updateTargetsByIndex,
    );
  }

  /// Previews card import and detects likely update candidates.
  static Future<ChangePlan<ImportCardsPayload, CardTemplate>>
  previewCardImport({
    required String deckId,
    required List<Map<String, dynamic>> incomingTemplateMaps,
    CardSimilarityConfig similarity = const CardSimilarityConfig(),
  }) async {
    final incoming = _decodeTemplates(incomingTemplateMaps);
    final existing = LocalDB.cardTemplate.getByDeckId(deckId);
    final candidates = <ImportCardMatchCandidate>[];
    final changes = <ChangedEntity<CardTemplate>>[];

    for (final template in incoming) {
      final incomingPreview = _templatePreview(template);
      final incomingText = incomingPreview.toLowerCase();

      ImportCardMatchCandidate? best;
      for (final local in existing) {
        if (!similarity.matchAcrossCardTypes &&
            local.runtimeType != template.runtimeType) {
          continue;
        }

        final score = _similarityScore(
          incoming: template,
          existing: local,
          incomingText: incomingText,
          existingText: _templatePreview(local).toLowerCase(),
          similarity: similarity,
        );
        if (score < similarity.threshold) continue;

        final candidate = ImportCardMatchCandidate(
          incomingTemplateId: template.id,
          existingTemplateId: local.id,
          score: score,
          existingPreview: _templatePreview(local),
          incomingPreview: incomingPreview,
        );
        if (best == null || candidate.score > best.score) {
          best = candidate;
        }
      }
      if (best != null) {
        candidates.add(best);
        final existingTemplateId = best.existingTemplateId;
        final local = existing.firstWhere(
          (template) => template.id == existingTemplateId,
        );
        changes.add(
          ChangedEntity(
            type: ChangeType.modified,
            source: ChangeSource.importExport,
            entityType: 'card_template',
            entityId: local.id,
            title: ChangeDifferenceHelper.templateTitle(local),
            subtitle: 'Likely imported card update',
            beforeChange: local,
            afterChange: template,
            changedProperties: ChangeDifferenceHelper.templates(
              local,
              template,
            ),
          ),
        );
      } else {
        changes.add(
          ChangedEntity(
            type: ChangeType.added,
            source: ChangeSource.importExport,
            entityType: 'card_template',
            entityId: template.id,
            title: ChangeDifferenceHelper.templateTitle(template),
            subtitle: 'Imported card will be added',
            afterChange: template,
          ),
        );
      }
    }

    return ChangePlan<ImportCardsPayload, CardTemplate>(
      payload: ImportCardsPayload(
        deckId: deckId,
        incomingTemplates: incomingTemplateMaps,
        candidates: candidates,
      ),
      changes: changes,
    );
  }

  /// JSON helper for [previewCardImport].
  static Future<ChangePlan<ImportCardsPayload, CardTemplate>>
  previewCardImportJson({
    required String deckId,
    required String rawJson,
    CardSimilarityConfig similarity = const CardSimilarityConfig(),
  }) async {
    final decoded = jsonDecode(rawJson);
    final incomingMaps = switch (decoded) {
      List _ =>
        decoded
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false),
      Map _ =>
        ((decoded as Map<String, dynamic>)['card_templates'] as List)
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false),
      _ => throw Exception(
        'Expected JSON array or object containing "card_templates".',
      ),
    };
    return previewCardImport(
      deckId: deckId,
      incomingTemplateMaps: incomingMaps,
      similarity: similarity,
    );
  }

  /// Applies card import decisions and returns detailed change logs.
  static Future<ChangeResult<List<CardTemplate>, CardTemplate>>
  applyCardImportPlan({
    required ChangePlan<ImportCardsPayload, CardTemplate> plan,
    required List<CardImportDecision> decisions,
  }) async {
    final logs = <ChangedEntity<CardTemplate>>[];
    final payload = plan.payload;
    final incoming = _decodeTemplates(payload.incomingTemplates);
    final decisionByIncomingId = {
      for (final decision in decisions) decision.incomingTemplateId: decision,
    };
    final written = <CardTemplate>[];

    for (final template in incoming) {
      final decision = decisionByIncomingId[template.id];
      if (decision?.action == CardImportAction.skip) {
        logs.add(
          ChangedEntity(
            type: ChangeType.skipped,
            source: ChangeSource.importExport,
            entityType: 'card_template',
            entityId: template.id,
            title: ChangeDifferenceHelper.templateTitle(template),
            subtitle: 'Skipped imported card',
            afterChange: template,
          ),
        );
        continue;
      }

      if (decision?.action == CardImportAction.updateExisting &&
          decision?.targetTemplateId != null) {
        final existing = LocalDB.cardTemplate.selectByPk({
          'id': decision!.targetTemplateId!,
        });
        if (existing == null) {
          logs.add(
            ChangedEntity(
              type: ChangeType.skipped,
              source: ChangeSource.importExport,
              entityType: 'card_template',
              entityId: decision.targetTemplateId!,
              title: 'Skipped card update',
              subtitle: 'Target template was not found locally.',
            ),
          );
          continue;
        }

        final updated = _copyTemplateWithIdentity(
          source: template,
          targetId: existing.id,
          deckId: payload.deckId,
          createdAt: existing.createdAt,
        );
        await LocalDB.cardTemplate.upsert(updated);
        written.add(updated);
        logs.add(
          ChangedEntity(
            type: ChangeType.modified,
            source: ChangeSource.importExport,
            entityType: 'card_template',
            entityId: existing.id,
            title: ChangeDifferenceHelper.templateTitle(updated),
            subtitle: 'Updated imported card',
            beforeChange: existing,
            afterChange: updated,
            changedProperties: ChangeDifferenceHelper.templates(
              existing,
              updated,
            ),
          ),
        );
        continue;
      }

      final created = _copyTemplateWithIdentity(
        source: template,
        targetId: uuid.v7(),
        deckId: payload.deckId,
        createdAt: DateTime.now(),
      );
      await LocalDB.cardTemplate.upsert(created);
      written.add(created);
      logs.add(
        ChangedEntity(
          type: ChangeType.added,
          source: ChangeSource.importExport,
          entityType: 'card_template',
          entityId: created.id,
          title: ChangeDifferenceHelper.templateTitle(created),
          subtitle: 'Imported new card',
          afterChange: created,
        ),
      );
    }

    final allTemplates = LocalDB.cardTemplate.getByDeckId(payload.deckId);
    await StudyCardService.syncDeckStudyCards(
      deckId: payload.deckId,
      templates: allTemplates,
    );

    await _storeBackup(
      operation: 'import_cards',
      entityType: 'card_templates',
      entityId: payload.deckId,
      title: 'Import cards into ${payload.deckId}',
      payload: {
        'deck_id': payload.deckId,
        'incoming_count': payload.incomingTemplates.length,
        'decision_count': decisions.length,
      },
      logs: logs,
    );

    return ChangeResult(value: written, changes: logs);
  }

  static Map<String, dynamic> _buildDeckPayload({
    required Deck deck,
    required List<CardTemplate> templates,
  }) {
    return {
      'format': 'boo_mondai_deck_v1',
      'exported_at': DateTime.now().toIso8601String(),
      'deck': deck.toMap(),
      'card_templates': [for (final template in templates) template.toMap()],
    };
  }

  static List<Map<String, dynamic>> _extractTemplateMaps(
    Map<String, dynamic> payload,
  ) {
    final raw = payload['card_templates'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  static List<CardTemplate> _decodeTemplates(List<Map<String, dynamic>> maps) {
    return maps.map(CardTemplateMapper.fromMap).toList(growable: false);
  }

  static Future<Uint8List?> _resolveMediaBytes(
    CardMediaAttachment attachment,
  ) async {
    final localPath = attachment.localPath;
    if (localPath != null) {
      final file = File(localPath);
      if (await file.exists()) {
        return file.readAsBytes();
      }
    }

    final publicUrl = attachment.publicUrl;
    if (publicUrl == null || publicUrl.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(publicUrl));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.bodyBytes;
      }
    } on Exception catch (e) {
      developer.log(
        'Failed to download media attachment ${attachment.id}',
        name: 'ImportExportService',
        error: e,
      );
    }
    return null;
  }

  static Future<Uint8List?> _resolveImageBytes(String? source) async {
    final value = source?.trim();
    if (value == null || value.isEmpty) return null;

    if (value.startsWith('data:') && value.contains(',')) {
      return base64Decode(value.substring(value.indexOf(',') + 1));
    }

    if (LocalImagePathHelper.isRemotePath(value)) {
      try {
        final response = await http.get(Uri.parse(value));
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response.bodyBytes;
        }
      } on Exception catch (e) {
        developer.log(
          'Failed to download bundled image source',
          name: 'ImportExportService',
          error: e,
        );
      }
      return null;
    }

    final file = File(value);
    if (await file.exists()) {
      return file.readAsBytes();
    }
    return null;
  }

  static Future<String?> _restoreBundledImage({
    required Directory tempDir,
    required String? contentPath,
    required String cacheKey,
    required String? remotePath,
  }) async {
    if (contentPath == null || contentPath.trim().isEmpty) return null;

    final file = File('${tempDir.path}/$contentPath');
    if (!await file.exists()) return null;

    return LocalImageCacheService.saveBytes(
      cacheKey: cacheKey,
      bytes: await file.readAsBytes(),
      mimeType: 'image/png',
      remotePath: remotePath,
    );
  }

  static String? _remotePathOrNull(String? value) {
    if (value == null || !LocalImagePathHelper.isRemotePath(value)) {
      return null;
    }
    return value;
  }

  static Deck? _findMatchingDeck(Deck incomingDeck) {
    final byId = LocalDB.deck.selectByPk({'id': incomingDeck.id});
    if (byId != null) return byId;

    final byTitle = LocalDB.deck.selectMany(
      where: (deck) => deck.title == incomingDeck.title,
      limit: 1,
    );
    return byTitle.isEmpty ? null : byTitle.first;
  }

  static String _safeBundleFileName(String title) {
    final sanitized = AttachmentLabelHelper.sanitizeLabel(
      title,
    ).replaceAll(RegExp(r'\s+'), '_');
    return sanitized.isEmpty ? 'deck' : sanitized;
  }

  static List<CardTemplate> _copyTemplatesForDeck({
    required List<CardTemplate> templates,
    required String deckId,
  }) {
    final idMap = {for (final template in templates) template.id: uuid.v7()};
    final attachmentIdMap = {
      for (final template in templates)
        for (final attachment in template.attachments) attachment.id: uuid.v7(),
    };
    final now = DateTime.now();
    return [
      for (final template in templates)
        _copyTemplate(
          source: template,
          targetDeckId: deckId,
          targetId: idMap[template.id]!,
          idMap: idMap,
          attachmentIdMap: attachmentIdMap,
          createdAt: now,
        ),
    ];
  }

  static CardTemplate _copyTemplateWithIdentity({
    required CardTemplate source,
    required String targetId,
    required String deckId,
    required DateTime createdAt,
  }) {
    final idMap = {source.id: targetId};
    return _copyTemplate(
      source: source,
      targetDeckId: deckId,
      targetId: targetId,
      idMap: idMap,
      attachmentIdMap: {
        for (final attachment in source.attachments) attachment.id: uuid.v7(),
      },
      createdAt: createdAt,
    );
  }

  static CardTemplate _copyTemplate({
    required CardTemplate source,
    required String targetDeckId,
    required String targetId,
    required Map<String, String> idMap,
    required Map<String, String> attachmentIdMap,
    required DateTime createdAt,
  }) {
    final now = DateTime.now();
    final attachments = _copyAttachments(
      source.attachments,
      targetTemplateId: targetId,
      attachmentIdMap: attachmentIdMap,
    );
    return switch (source) {
      FlashcardTemplate t => FlashcardTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        attachments: attachments,
        frontText: t.frontText,
        backText: t.backText,
        frontImageUrl: t.frontImageUrl,
        backImageUrl: t.backImageUrl,
        frontAudioUrl: t.frontAudioUrl,
        backAudioUrl: t.backAudioUrl,
        cardType: t.cardType,
      ),
      IdentificationTemplate t => IdentificationTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        attachments: attachments,
        promptText: t.promptText,
        acceptedAnswers: t.acceptedAnswers,
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      MultipleChoiceTemplate t => MultipleChoiceTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        attachments: attachments,
        questionPrompt: t.questionPrompt,
        options: [
          for (final option in t.options)
            MultipleChoiceOption(
              id: uuid.v7(),
              templateId: targetId,
              optionText: option.optionText,
              isCorrect: option.isCorrect,
              displayOrder: option.displayOrder,
            ),
        ],
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      FillInTheBlanksTemplate t => FillInTheBlanksTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        attachments: attachments,
        segments: [
          for (final segment in t.segments)
            FillInTheBlankSegment(
              id: uuid.v7(),
              cardId: targetId,
              fullText: segment.fullText,
              blankStart: segment.blankStart,
              blankEnd: segment.blankEnd,
              correctAnswer: segment.correctAnswer,
            ),
        ],
      ),
      MatchMadnessTemplate t => MatchMadnessTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        attachments: attachments,
        pairs: [
          for (final pair in t.pairs)
            MatchMadnessPair(
              id: uuid.v7(),
              templateId: targetId,
              sourceTemplateId: pair.sourceTemplateId == null
                  ? null
                  : idMap[pair.sourceTemplateId] ?? pair.sourceTemplateId,
              term: pair.term,
              match: pair.match,
              isAutoPicked: pair.isAutoPicked,
              displayOrder: pair.displayOrder,
            ),
        ],
      ),
      WordScrambleTemplate t => WordScrambleTemplate(
        id: targetId,
        deckId: targetDeckId,
        sortOrder: t.sortOrder,
        createdAt: createdAt,
        updatedAt: now,
        sourceTemplateId: t.sourceTemplateId ?? t.id,
        tags: t.tags,
        attachments: attachments,
        sentenceToScramble: t.sentenceToScramble,
        imageUrl: t.imageUrl,
        audioUrl: t.audioUrl,
      ),
      _ => throw UnsupportedError(
        'Unsupported card template type: ${source.runtimeType}',
      ),
    };
  }

  static List<CardAttachment> _copyAttachments(
    List<CardAttachment> attachments, {
    required String targetTemplateId,
    required Map<String, String> attachmentIdMap,
  }) {
    return [
      for (final attachment in attachments)
        switch (attachment) {
          CardMediaAttachment a => CardMediaAttachment(
            id: attachmentIdMap[a.id] ?? uuid.v7(),
            templateId: targetTemplateId,
            type: a.type,
            label: a.label,
            storagePath: a.storagePath,
            publicUrl: a.publicUrl,
            localPath: a.localPath,
            mimeType: a.mimeType,
            altText: a.altText,
            createdAt: a.createdAt,
          ),
          CardLinkAttachment a => CardLinkAttachment(
            id: attachmentIdMap[a.id] ?? uuid.v7(),
            templateId: targetTemplateId,
            type: a.type,
            label: a.label,
            url: a.url,
            altText: a.altText,
            createdAt: a.createdAt,
          ),
        },
    ];
  }

  static int _similarityScore({
    required CardTemplate incoming,
    required CardTemplate existing,
    required String incomingText,
    required String existingText,
    required CardSimilarityConfig similarity,
  }) {
    if (similarity.matchBySourceTemplateId) {
      final incomingSource = incoming.sourceTemplateId;
      final existingSource = existing.sourceTemplateId;
      if (incomingSource != null &&
          existingSource != null &&
          incomingSource == existingSource) {
        return 100;
      }
      if (incomingSource != null && incomingSource == existing.id) return 100;
      if (existingSource != null && existingSource == incoming.id) return 100;
    }

    return _diceCoefficientScore(incomingText, existingText);
  }

  static int _diceCoefficientScore(String a, String b) {
    if (a == b) return 100;
    if (a.isEmpty || b.isEmpty) return 0;
    if (a.length == 1 || b.length == 1) {
      return a[0] == b[0] ? 100 : 0;
    }

    final aPairs = _bigrams(a);
    final bPairs = _bigrams(b);
    var overlap = 0;
    final bCount = <String, int>{};
    for (final pair in bPairs) {
      bCount[pair] = (bCount[pair] ?? 0) + 1;
    }
    for (final pair in aPairs) {
      final count = bCount[pair] ?? 0;
      if (count > 0) {
        overlap++;
        bCount[pair] = count - 1;
      }
    }
    final score = (2 * overlap) / (aPairs.length + bPairs.length);
    return (score * 100).round();
  }

  static List<String> _bigrams(String value) {
    final trimmed = value.trim().toLowerCase();
    if (trimmed.length < 2) return [trimmed];
    final pairs = <String>[];
    for (var i = 0; i < trimmed.length - 1; i++) {
      pairs.add(trimmed.substring(i, i + 2));
    }
    return pairs;
  }

  static String _templatePreview(CardTemplate template) {
    return switch (template) {
      FlashcardTemplate t => '${t.frontText} -> ${t.backText}',
      IdentificationTemplate t => '${t.promptText} -> ${t.acceptedAnswers}',
      MultipleChoiceTemplate t =>
        '${t.questionPrompt} -> ${t.options.where((o) => o.isCorrect).map((o) => o.optionText).join(', ')}',
      FillInTheBlanksTemplate t =>
        t.segments.isEmpty
            ? ''
            : '${t.segments.first.fullText} -> ${t.segments.map((s) => s.correctAnswer).join(', ')}',
      MatchMadnessTemplate t =>
        t.pairs.take(3).map((p) => '${p.term}:${p.match}').join(', '),
      WordScrambleTemplate t => t.sentenceToScramble,
      _ => '',
    };
  }

  static Future<void> _storeBackup({
    required String operation,
    required String entityType,
    required String? entityId,
    required String title,
    required Map<String, dynamic> payload,
    required List<ChangedEntity> logs,
  }) async {
    final backup = ImportExportBackup(
      id: uuid.v7(),
      operation: operation,
      entityType: entityType,
      entityId: entityId,
      title: title,
      payloadJson: jsonEncode(payload),
      changeLogsJson: jsonEncode([for (final log in logs) log.toJson()]),
      createdAt: DateTime.now(),
    );
    await LocalDB.importExportBackup.upsert(backup);
  }
}
