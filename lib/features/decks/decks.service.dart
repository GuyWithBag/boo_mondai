import 'dart:io' hide ContentType;

import 'package:boo_mondai/features/filesystem.handler/filesystem.handler.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        Deck,
        DecksDirectoryPaths,
        LocalDB,
        RemoteDB,
        SyncDeletionPolicy,
        Tag,
        uuid,
        Content;
import 'package:file_picker/file_picker.dart' show PlatformFile;

abstract final class DecksService {
  static Future<Deck> createAndUpsert({
    String? title,
    String? profileId,
    bool isPublished = false,
  }) async {
    final resolvedTitle = await nextDeckTitle();
    final resolvedProfileId =
        profileId ?? LocalDB.currentProfile.getOrCreate().id;
    final now = DateTime.now();

    final deck = Deck(
      id: uuid.v7(),
      profileId: resolvedProfileId,
      title: resolvedTitle.trim(),
      updatedAt: now,
      createdAt: now,
    );

    await LocalDB.deck.upsert(deck);
    return deck;
  }

  static Future<String> nextDeckTitle({
    String baseTitle = 'Untitled Deck',
  }) async {
    // final pathAlreadyExsists = File('');
    final existingTitles = LocalDB.deck
        .selectMany()
        .map((deck) => deck.title.trim().toLowerCase())
        .toSet();

    for (var index = 1; true; index++) {
      final candidate = '$baseTitle $index';
      if (existingTitles.contains(candidate.toLowerCase())) {
        continue;
      }

      final directoryExists =
          await FileSystemHandler.doesDirectoryExistRelatively(
            DecksDirectoryPaths.root(deckTitle: candidate),
          );
      if (directoryExists) {
        continue;
      }

      return candidate;
    }
  }

  static Future<Deck?> upsert({
    required Deck deck,
    // String? title,
    // String? shortDescription,
    // String? longDescription,
    // bool? isPublished,
  }) async {
    final updatedDeck = deck.copyWith(updatedAt: DateTime.now());
    LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<void> setTitle({
    required Deck deck,
    required String title,
  }) async {
    final relativePath = DecksDirectoryPaths.root(deckTitle: deck.title);
    final absolutePath = await FileSystemHandler.getAbsolutePathOfRelativePath(
      relativePath,
    );

    var directory = Directory(absolutePath);
    try {
      directory = await directory.rename(title);
    } catch (e) {
      rethrow;
    }
    final updatedDeck = deck.copyWith(title: title.trim());

    await LocalDB.deck.upsert(updatedDeck);
  }

  static Future<Deck?> setShortDescription({
    required Deck deck,
    required String shortDescription,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final trimmedShortDescription = shortDescription.trim();
    if (trimmedShortDescription == deck.shortDescription) {
      return null;
    }

    final updatedDeck = deck.copyWith(
      shortDescription: trimmedShortDescription,
    );

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> setLongDescription({
    required Deck deck,
    required String longDescription,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final trimmedLongDescription = longDescription.trim();
    if (trimmedLongDescription == deck.longDescription) {
      return null;
    }

    final updatedDeck = deck.copyWith(longDescription: trimmedLongDescription);
    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> setPublished({
    required Deck deck,
    required bool isPublished,
  }) async {
    if (isPublished == deck.isPublished) {
      return null;
    }

    final updatedDeck = deck.copyWith(isPublished: isPublished);

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> setTags({
    required Deck deck,
    required Content content,
    required List<String> tagNames,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final normalizedTagNames = tagNames
        .map((tagName) => tagName.trim())
        .where((tagName) => tagName.isNotEmpty)
        .toList();
    final currentTagNames = deck.tags.map((tag) => tag.name).toList();

    if (_sameTagNames(normalizedTagNames, currentTagNames)) {
      return null;
    }

    final existingTagsByName = {
      for (final tag in deck.tags) tag.name.toLowerCase(): tag,
    };
    final updatedTags = [
      for (final tagName in normalizedTagNames)
        existingTagsByName[tagName.toLowerCase()] ??
            Tag.createNow(name: tagName, profileId: deck.profileId),
    ];
    final updatedDeck = deck.copyWith(tags: updatedTags);
    final updatedContent = content.copyWith(updatedAt: DateTime.now());

    await LocalDB.contents.upsert(updatedContent);
    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<void> setCoverImageUrlByFile({
    required Deck deck,
    required Content content,
    required PlatformFile file,
  }) async {
    if (!deck.isEditable) {
      return;
    }

    final path = DecksDirectoryPaths.coverImage(deckTitle: deck.title);
    final absolutePath = await FileSystemHandler.getAbsolutePathOfRelativePath(
      path,
    );
    final file = File(absolutePath);
    final bytes = await file.readAsBytes();
    file.writeAsBytes(bytes);

    final remoteUrl = await RemoteDB.publicBucket.uploadBytes(path, bytes);
    final updatedDeck = deck.copyWith(coverImageUrl: remoteUrl);
    final updatedContent = content.copyWith(updatedAt: DateTime.now());

    await LocalDB.contents.upsert(updatedContent);
    await LocalDB.deck.upsert(updatedDeck);
    return;
  }

  // static String? getCoverImageUrl(Deck deck) {
  //   final remoteUrl = deck.coverImageUrl;
  //   final localPath = StoredMediaService.getFileByPath(
  //     DecksDirectoryPaths.deckCoverImage(deckTitle: deck.title),
  //   )?.path;

  //   if (localPath != null) {
  //     return localPath;
  //   }

  //   if (remoteUrl == null) {
  //     return null;
  //   }

  //   return remoteUrl;
  // }

  // ToDo: Throughly fix this
  static Future<void> deleteDeckCascades({
    required Deck deck,
    // required DeckListing listing,
    bool keepReviewLogs = true,
  }) async {
    if (!deck.isEditable) return;

    final now = DateTime.now();
    final purgeAfter = SyncDeletionPolicy.current().purgeAfter(now);
    final profileId = deck.profileId;
    final studyCards = LocalDB.studyCard.getByDeckId(deck.id);
    final studyCardIds = studyCards.map((card) => card.id).toSet();
    final cardTemplates = LocalDB.cardTemplate.getByDeckId(deck.id);
    final templateIds = cardTemplates.map((template) => template.id).toSet();
    final fsrsCards = LocalDB.fsrsCard.selectMany(
      where: (card) => studyCardIds.contains(card.studyCardId),
    );
    final deckTags = LocalDB.deckTag.getTagsForDeck(deck.id);
    final templateTags = LocalDB.cardTemplateTag.getTagsForTemplates(
      templateIds,
    );
    final studyCardTags = LocalDB.userStudyCardTag.getTagsForCards(
      studyCardIds,
    );
    final shouldSyncDeletion = AuthService.isAuthenticatedRemote;

    final tagIdsToCheck = {
      for (final tag in deckTags) tag.tagId,
      for (final tag in templateTags) tag.tagId,
      for (final tag in studyCardTags) tag.tagId,
    };

    if (!keepReviewLogs) {
      final fsrsCardIds = fsrsCards.map((card) => card.id).toSet();
      final reviewLogs = LocalDB.reviewLogs.selectMany(
        where: (log) => fsrsCardIds.contains(log.fsrsCardId),
      );
      await LocalDB.reviewLogs.deleteManyByPk([
        for (final log in reviewLogs) {'id': log.id},
      ]);
    }

    final listing = LocalDB.deckListing.selectByPkIncludingDeleted({
      'deck_id': deck.id,
    });
    final content = listing == null
        ? null
        : LocalDB.contents.selectByPk({
            'id': listing.contentId,
          }, includeDeleted: true);

    if (shouldSyncDeletion) {
      await LocalDB.fsrsCard.upsertMany([
        for (final card in fsrsCards)
          card.copyWith(updatedAt: now, deletedAt: now, purgeAfter: purgeAfter),
      ]);
      await LocalDB.studyCard.upsertMany([
        for (final card in studyCards)
          card.copyWith(updatedAt: now, deletedAt: now, purgeAfter: purgeAfter),
      ]);
      await LocalDB.cardTemplate.upsertMany([
        for (final template in cardTemplates)
          template.copyWith(
            updatedAt: now,
            deletedAt: now,
            purgeAfter: purgeAfter,
          ),
      ]);
      if (listing != null && content != null) {
        await LocalDB.contents.upsert(
          content.copyWith(
            updatedAt: now,
            deletedAt: now,
            purgeAfter: purgeAfter,
          ),
        );

        await LocalDB.deckListing.upsert(listing);
      }

      await LocalDB.deck.upsert(
        deck.copyWith(updatedAt: now, deletedAt: now, purgeAfter: purgeAfter),
      );
    } else {
      final fsrsCardIds = fsrsCards.map((card) => card.id).toSet();
      final reviewLogs = LocalDB.reviewLogs.selectMany(
        where: (log) => fsrsCardIds.contains(log.fsrsCardId),
      );
      await LocalDB.reviewLogs.deleteManyByPk([
        for (final log in reviewLogs) {'id': log.id},
      ]);
      await LocalDB.fsrsCard.deleteManyByPk([
        for (final card in fsrsCards) {'id': card.id},
      ]);
      await LocalDB.studyCard.deleteManyByPk([
        for (final card in studyCards) {'id': card.id},
      ]);
      await LocalDB.cardTemplate.deleteManyByPk([
        for (final template in cardTemplates) {'id': template.id},
      ]);
      if (listing != null) {
        await LocalDB.deckListing.deleteByPk({'deck_id': listing.deckId});
      }
      await LocalDB.deck.deleteByPk({'id': deck.id});
    }

    await LocalDB.userStudyCardTag.deleteByStudyCardIds(studyCardIds);
    await LocalDB.cardTemplateTag.deleteByTemplateIds(templateIds);
    await LocalDB.deckTag.deleteByDeckId(deck.id);

    // final orphanedTags = _orphanedOwnedTags(tagIdsToCheck, profileId);
    // if (orphanedTags.isEmpty) return;

    // await LocalDB.tag.deleteManyByPk([
    //   for (final tag in orphanedTags) {'id': tag.id},
    // ]);
  }

  // static List<Tag> _orphanedOwnedTags(Set<String> tagIds, String profileId) {
  //   return LocalDB.tag
  //       .selectManyByIds(tagIds)
  //       .where((tag) {
  //         if (tag.profileId != profileId) return false;
  //         return !LocalDB.deckTag.isTagReferenced(tag.id) &&
  //             !LocalDB.cardTemplateTag.isTagReferenced(tag.id) &&
  //             !LocalDB.userStudyCardTag.isTagReferenced(tag.id) &&
  //             !LocalDB.deck.selectMany().any(
  //               (deck) => deck.tags.any((deckTag) => deckTag.id == tag.id),
  //             ) &&
  //             !LocalDB.cardTemplate.selectMany().any(
  //               (template) => template.tags.any(
  //                 (templateTag) => templateTag.id == tag.id,
  //               ),
  //             ) &&
  //             !LocalDB.studyCard.selectMany().any(
  //               (card) => card.personalTags.any(
  //                 (personalTag) => personalTag.id == tag.id,
  //               ),
  //             );
  //       })
  //       .toList(growable: false);
  // }

  static bool _sameTagNames(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }

    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) {
        return false;
      }
    }

    return true;
  }
}
