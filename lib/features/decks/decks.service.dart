import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        LocalDB,
        AuthService,
        StoredMediaService,
        StoredMediaPathHelper,
        SyncDeletionPolicy,
        Tag,
        StringHelper,
        DeckListingsService;
import 'package:file_picker/file_picker.dart' show PlatformFile;

abstract final class DecksService {
  static Future<Deck?> update({
    required Deck deck,
    String? title,
    String? shortDescription,
    String? longDescription,
    bool? isPublished,
  }) async {
    var updatedDeck = deck;
    var changed = false;

    if (title != null) {
      final nextDeck = await setTitle(deck: updatedDeck, title: title);
      if (nextDeck != null) {
        updatedDeck = nextDeck;
        changed = true;
      }
    }

    if (shortDescription != null) {
      final nextDeck = await setShortDescription(
        deck: updatedDeck,
        shortDescription: shortDescription,
      );
      if (nextDeck != null) {
        updatedDeck = nextDeck;
        changed = true;
      }
    }

    if (longDescription != null) {
      final nextDeck = await setLongDescription(
        deck: updatedDeck,
        longDescription: longDescription,
      );
      if (nextDeck != null) {
        updatedDeck = nextDeck;
        changed = true;
      }
    }

    if (isPublished != null) {
      final nextDeck = await setPublished(
        deck: updatedDeck,
        isPublished: isPublished,
      );
      if (nextDeck != null) {
        updatedDeck = nextDeck;
        changed = true;
      }
    }

    return changed ? updatedDeck : null;
  }

  static Future<Deck?> setTitle({
    required Deck deck,
    required String title,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty || trimmedTitle == deck.title) {
      return null;
    }

    final updatedDeck = deck.copyWith(
      title: trimmedTitle,
      updatedAt: DateTime.now(),
    );

    await StoredMediaService.renameFolderByPrefix(
      oldPrefix: deck.title,
      newPrefix: updatedDeck.title,
    );
    await LocalDB.deck.upsert(updatedDeck);

    return updatedDeck;
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
      updatedAt: DateTime.now(),
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

    final updatedDeck = deck.copyWith(
      longDescription: trimmedLongDescription,
      updatedAt: DateTime.now(),
    );

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

    final updatedDeck = deck.copyWith(
      isPublished: isPublished,
      updatedAt: DateTime.now(),
    );

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> setTags({
    required Deck deck,
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
    final updatedDeck = deck.copyWith(
      tags: updatedTags,
      updatedAt: DateTime.now(),
    );

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> setCoverImageUrl({
    required Deck deck,
    required PlatformFile file,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final localPath = await StoredMediaService.storeFile(
      path: StoredMediaPathHelper.deckCoverImage(deckTitle: deck.title),
      file: file,
    );
    if (localPath == null) {
      return null;
    }

    final updatedDeck = deck.copyWith(updatedAt: DateTime.now());

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static String? getCoverImageUrl(Deck deck) {
    final remoteUrl = StringHelper.toTrimmedOrNull(deck.coverImageUrl);
    final localPath = StoredMediaService.getFileByPath(
      StoredMediaPathHelper.deckCoverImage(deckTitle: deck.title),
    )?.path;

    if (localPath != null) {
      return localPath;
    }

    if (remoteUrl == null) {
      return null;
    }

    final cachedRemotePath = StoredMediaService.getFileByRemoteUrl(
      remoteUrl,
    )?.path;
    if (cachedRemotePath != null) {
      return cachedRemotePath;
    }

    return remoteUrl;
  }

  static Future<Deck> createAndUpsertListing(Deck deck) async {
    final listing = await DeckListingsService.createListing(deck);

    final updatedDeck = deck.copyWith(
      updatedAt: DateTime.now(),
      listing: listing,
    );

    return updatedDeck;
  }

  static Future<void> deleteDeckCascade({
    required Deck deck,
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
      final reviewLogs = LocalDB.reviewLog.selectMany(
        where: (log) => fsrsCardIds.contains(log.fsrsCardId),
      );
      await LocalDB.reviewLog.deleteManyByPk([
        for (final log in reviewLogs) {'id': log.id},
      ]);
    }

    final listing =
        deck.listing ??
        LocalDB.deckListing.selectByPkIncludingDeleted({'deck_id': deck.id});

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
      if (listing != null) {
        await LocalDB.deckListing.upsert(
          listing.copyWith(
            updatedAt: now,
            deletedAt: now,
            purgeAfter: purgeAfter,
          ),
        );
      }
      await LocalDB.deck.upsert(
        deck.copyWith(
          updatedAt: now,
          deletedAt: now,
          purgeAfter: purgeAfter,
          listing: null,
        ),
      );
    } else {
      final fsrsCardIds = fsrsCards.map((card) => card.id).toSet();
      final reviewLogs = LocalDB.reviewLog.selectMany(
        where: (log) => fsrsCardIds.contains(log.fsrsCardId),
      );
      await LocalDB.reviewLog.deleteManyByPk([
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

    final orphanedTags = _orphanedOwnedTags(tagIdsToCheck, profileId);
    if (orphanedTags.isEmpty) return;

    await LocalDB.tag.deleteManyByPk([
      for (final tag in orphanedTags) {'id': tag.id},
    ]);
  }

  static List<Tag> _orphanedOwnedTags(Set<String> tagIds, String profileId) {
    return LocalDB.tag
        .selectManyByIds(tagIds)
        .where((tag) {
          if (tag.profileId != profileId) return false;
          return !LocalDB.deckTag.isTagReferenced(tag.id) &&
              !LocalDB.cardTemplateTag.isTagReferenced(tag.id) &&
              !LocalDB.userStudyCardTag.isTagReferenced(tag.id) &&
              !LocalDB.deck.selectMany().any(
                (deck) => deck.tags.any((deckTag) => deckTag.id == tag.id),
              ) &&
              !LocalDB.cardTemplate.selectMany().any(
                (template) => template.tags.any(
                  (templateTag) => templateTag.id == tag.id,
                ),
              ) &&
              !LocalDB.studyCard.selectMany().any(
                (card) => card.personalTags.any(
                  (personalTag) => personalTag.id == tag.id,
                ),
              );
        })
        .toList(growable: false);
  }

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
