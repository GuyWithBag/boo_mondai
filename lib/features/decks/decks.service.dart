import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        Deck,
        DeckListing,
        DeckSyncSession,
        LocalDB,
        StoredMediaService,
        FolderPaths,
        FolderPathStoredMediaPath,
        ImageHelper,
        RemoteDB,
        SyncDeletion,
        SyncDeletionService,
        SyncIndexEntry,
        Tag,
        VisibilityState,
        StringHelper,
        ListHelper;
import 'package:file_picker/file_picker.dart' show PlatformFile;

abstract final class DecksService {
  static String? getCoverImageSource(Deck deck) {
    final remoteUrl = StringHelper.toTrimmedOrNull(deck.coverImageUrl);
    return StoredMediaService.getFileByPath(
          FolderPaths.deckCoverImage(deck.title).toStoredMediaPath(),
        )?.path ??
        (remoteUrl == null
            ? null
            : StoredMediaService.getFileByRemoteUrl(remoteUrl)?.path) ??
        remoteUrl;
  }

  static String? getListingFeaturedImageSource({
    required Deck deck,
    int index = 0,
  }) {
    final listing = deck.listing;
    if (listing == null) return getCoverImageSource(deck);

    final remoteUrl = StringHelper.toTrimmedOrNull(
      ListHelper.getAtOrNull(listing.featuredImages, index),
    );

    return StoredMediaService.getFileByPath(
          FolderPaths.deckListingFeaturedImage(
            deck.title,
            index,
          ).toStoredMediaPath(),
        )?.path ??
        (remoteUrl == null
            ? null
            : StoredMediaService.getFileByRemoteUrl(remoteUrl)?.path) ??
        remoteUrl ??
        getCoverImageSource(deck);
  }

  static List<String> getListingCarouselImageSources(Deck deck) {
    final listingImages = deck.listing?.featuredImages ?? const <String>[];
    final resolved = <String>[];

    for (var index = 0; index < listingImages.length; index++) {
      final image = getListingFeaturedImageSource(deck: deck, index: index);
      if (image != null && !resolved.contains(image)) {
        resolved.add(image);
      }
    }

    final cover = getCoverImageSource(deck);
    if (cover != null && !resolved.contains(cover)) {
      resolved.add(cover);
    }

    return resolved;
  }

  static Future<List<String>> loadDeckIdsForSyncSession(
    DeckSyncSession session,
  ) async {
    final explicitDeckId = session.deckId;
    if (explicitDeckId != null) return [explicitDeckId];

    final localDecks = session.decks.selectSyncIndexByUserIdAndOptionalDeckId(
      userId: session.userId,
      deckId: session.deckId,
    );
    final remoteDecks = await session.remoteDecks
        .selectSyncIndexByUserIdAndOptionalDeckId(
          userId: session.userId,
          deckId: session.deckId,
        );

    return {
      for (final deck in localDecks) deck.id,
      for (final deck in remoteDecks) deck.id,
    }.toList(growable: false);
  }

  static Future<List<SyncIndexEntry>> loadLocalDeckSyncIndexForSyncSession(
    DeckSyncSession session,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.decks,
    );
    final entries = session.decks.selectSyncIndexByUserIdAndOptionalDeckId(
      userId: session.userId,
      deckId: session.deckId,
    );
    return SyncDeletionService.withoutDeletedIndexEntries(entries, deletedIds);
  }

  static Future<List<SyncIndexEntry>> loadRemoteDeckSyncIndexForSyncSession(
    DeckSyncSession session,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.decks,
    );
    final entries = await session.remoteDecks
        .selectSyncIndexByUserIdAndOptionalDeckId(
          userId: session.userId,
          deckId: session.deckId,
        );
    return SyncDeletionService.withoutDeletedIndexEntries(entries, deletedIds);
  }

  static Future<List<Deck>> loadLocalDecksByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.decks,
    );
    return SyncDeletionService.withoutDeletedItems(
      session.decks.selectManyByIds(ids),
      deletedIds,
      (deck) => deck.id,
    );
  }

  static Future<List<Deck>> loadRemoteDecksByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.decks,
    );
    final decks = await session.remoteDecks.selectManyByIds(ids);
    return SyncDeletionService.withoutDeletedItems(
      decks,
      deletedIds,
      (deck) => deck.id,
    );
  }

  static Future<void> deleteDeckCascade({
    required Deck deck,
    bool keepReviewLogs = true,
  }) async {
    if (!deck.isEditable) return;

    final now = DateTime.now();
    final userId = deck.userId;
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

    final tagIdsToCheck = {
      for (final tag in deckTags) tag.tagId,
      for (final tag in templateTags) tag.tagId,
      for (final tag in studyCardTags) tag.tagId,
    };

    final deletions = <SyncDeletion>[
      SyncDeletionService.createDeckScoped(
        entityType: SyncDeletionService.decks,
        entityId: deck.id,
        userId: userId,
        deckId: deck.id,
        deletedAt: now,
      ),
      SyncDeletionService.createDeckScoped(
        entityType: SyncDeletionService.deckListings,
        entityId: deck.id,
        userId: userId,
        deckId: deck.id,
        deletedAt: now,
      ),
      for (final template in cardTemplates)
        SyncDeletionService.createDeckScoped(
          entityType: SyncDeletionService.cardTemplates,
          entityId: template.id,
          userId: userId,
          deckId: deck.id,
          deletedAt: now,
        ),
      for (final card in studyCards)
        SyncDeletionService.createDeckScoped(
          entityType: SyncDeletionService.studyCards,
          entityId: card.id,
          userId: userId,
          deckId: deck.id,
          deletedAt: now,
        ),
      for (final card in fsrsCards)
        SyncDeletionService.createDeckScoped(
          entityType: SyncDeletionService.fsrsCards,
          entityId: card.id,
          userId: userId,
          deckId: deck.id,
          deletedAt: now,
        ),
      for (final tag in deckTags)
        SyncDeletionService.createDeckScoped(
          entityType: SyncDeletionService.deckTags,
          entityId: SyncDeletionService.compositeEntityId({
            'deck_id': tag.deckId,
            'tag_id': tag.tagId,
          }),
          userId: userId,
          deckId: deck.id,
          deletedAt: now,
        ),
      for (final tag in templateTags)
        SyncDeletionService.createDeckScoped(
          entityType: SyncDeletionService.cardTemplateTags,
          entityId: SyncDeletionService.compositeEntityId({
            'template_id': tag.templateId,
            'tag_id': tag.tagId,
          }),
          userId: userId,
          deckId: deck.id,
          deletedAt: now,
        ),
      for (final tag in studyCardTags)
        SyncDeletionService.createDeckScoped(
          entityType: SyncDeletionService.userStudyCardTags,
          entityId: SyncDeletionService.compositeEntityId({
            'study_cards_id': tag.studyCardId,
            'tag_id': tag.tagId,
            'user_id': tag.userId,
          }),
          userId: userId,
          deckId: deck.id,
          deletedAt: now,
        ),
    ];

    await LocalDB.syncDeletion.upsertMany(deletions);

    if (!keepReviewLogs) {
      final fsrsCardIds = fsrsCards.map((card) => card.id).toSet();
      final reviewLogs = LocalDB.reviewLog.selectMany(
        where: (log) => fsrsCardIds.contains(log.fsrsCardId),
      );
      await LocalDB.reviewLog.deleteManyByPk([
        for (final log in reviewLogs) {'id': log.id},
      ]);
    }

    await LocalDB.userStudyCardTag.deleteByStudyCardIds(studyCardIds);
    await LocalDB.cardTemplateTag.deleteByTemplateIds(templateIds);
    await LocalDB.deckTag.deleteByDeckId(deck.id);
    await LocalDB.fsrsCard.deleteManyByPk([
      for (final card in fsrsCards) {'id': card.id},
    ]);
    await LocalDB.studyCard.deleteByDeckId(deck.id);
    await LocalDB.cardTemplate.deleteByDeckId(deck.id);
    await LocalDB.deckListing.deleteByPk({'deck_id': deck.id});
    await LocalDB.deck.deleteByPk({'id': deck.id});

    final orphanedTags = _orphanedOwnedTags(tagIdsToCheck, userId);
    if (orphanedTags.isEmpty) return;

    await LocalDB.syncDeletion.upsertMany([
      for (final tag in orphanedTags)
        SyncDeletionService.create(
          entityType: SyncDeletionService.tags,
          entityId: tag.id,
          userId: userId,
          scopeType: 'user',
          scopeId: userId,
          deletedAt: now,
        ),
    ]);
    await LocalDB.tag.deleteManyByPk([
      for (final tag in orphanedTags) {'id': tag.id},
    ]);
  }

  static List<Tag> _orphanedOwnedTags(Set<String> tagIds, String userId) {
    return LocalDB.tag
        .selectManyByIds(tagIds)
        .where((tag) {
          if (tag.userId != userId) return false;
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

  static Future<Deck> createListingDraft(Deck deck) async {
    final now = DateTime.now();
    final listing = DeckListing(
      deckId: deck.id,
      createdAt: now,
      updatedAt: now,
    );
    final updatedDeck = deck.copyWith(listing: listing, updatedAt: now);

    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.deckListing.upsert(listing);

    return updatedDeck;
  }

  static Future<Deck> saveListingDraft(Deck deck) async {
    await LocalDB.deck.upsert(deck);

    final listing = deck.listing;
    if (listing != null) {
      await LocalDB.deckListing.upsert(listing);
    }

    return deck;
  }

  static Future<Deck> publishListingDraft(Deck deck) async {
    final now = DateTime.now();
    final listing =
        (deck.listing ??
                DeckListing(deckId: deck.id, createdAt: now, updatedAt: now))
            .copyWith(updatedAt: now);
    final publishedDeck = deck.copyWith(
      isPublished: true,
      visibilityState: VisibilityState.public,
      listing: listing,
      updatedAt: now,
    );

    await saveListingDraft(publishedDeck);
    await RemoteDB.deck.upsert(publishedDeck);
    await RemoteDB.deckListing.upsert(listing);

    return publishedDeck;
  }

  static Future<Deck> unpublishListingDraft(Deck deck) async {
    final now = DateTime.now();
    final unpublishedDeck = deck.copyWith(
      isPublished: false,
      visibilityState: VisibilityState.private,
      updatedAt: now,
    );

    await saveListingDraft(unpublishedDeck);
    await RemoteDB.deck.upsert(unpublishedDeck);

    return unpublishedDeck;
  }

  static Future<Deck?> updateTitle({
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

  static Future<Deck?> updateShortDescription({
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

  static Future<Deck?> updateLongDescription({
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

  static Future<Deck?> updatePublished({
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
      final nextDeck = await updateTitle(deck: updatedDeck, title: title);
      if (nextDeck != null) {
        updatedDeck = nextDeck;
        changed = true;
      }
    }

    if (shortDescription != null) {
      final nextDeck = await updateShortDescription(
        deck: updatedDeck,
        shortDescription: shortDescription,
      );
      if (nextDeck != null) {
        updatedDeck = nextDeck;
        changed = true;
      }
    }

    if (longDescription != null) {
      final nextDeck = await updateLongDescription(
        deck: updatedDeck,
        longDescription: longDescription,
      );
      if (nextDeck != null) {
        updatedDeck = nextDeck;
        changed = true;
      }
    }

    if (isPublished != null) {
      final nextDeck = await updatePublished(
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

  static Future<Deck?> updateTags({
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
            Tag.createNow(name: tagName, userId: deck.userId),
    ];
    final updatedDeck = deck.copyWith(
      tags: updatedTags,
      updatedAt: DateTime.now(),
    );

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> updateCoverImage({
    required Deck deck,
    required PlatformFile file,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final localPath = await StoredMediaService.storeFile(
      path: FolderPaths.deckCoverImage(deck.title).toStoredMediaPath(),
      file: file,
    );
    if (localPath == null) {
      return null;
    }

    final updatedDeck = deck.copyWith(updatedAt: DateTime.now());

    await LocalDB.deck.upsert(updatedDeck);
    return updatedDeck;
  }

  static Future<Deck?> updateListingFeaturedImage({
    required Deck deck,
    required int index,
    required PlatformFile file,
  }) async {
    if (!deck.isEditable || index < 0) {
      return null;
    }

    final now = DateTime.now();
    final listing =
        deck.listing ??
        DeckListing(deckId: deck.id, createdAt: now, updatedAt: now);
    final featuredImages = listing.featuredImages.toList();
    final targetIndex = index <= featuredImages.length
        ? index
        : featuredImages.length;

    final localPath = await StoredMediaService.storeFile(
      path: FolderPaths.deckListingFeaturedImage(
        deck.title,
        targetIndex,
      ).toStoredMediaPath(),
      file: file,
    );
    if (localPath == null) {
      return null;
    }

    if (targetIndex < featuredImages.length) {
      featuredImages[targetIndex] =
          ImageHelper.isRemoteUrl(featuredImages[targetIndex])
          ? featuredImages[targetIndex]
          : '';
    } else {
      featuredImages.add('');
    }

    final updatedListing = listing.copyWith(
      featuredImages: featuredImages,
      updatedAt: now,
    );
    final updatedDeck = deck.copyWith(listing: updatedListing, updatedAt: now);

    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.deckListing.upsert(updatedListing);
    return updatedDeck;
  }

  static Future<Deck?> addListingFeaturedCard({
    required Deck deck,
    required CardTemplate template,
  }) async {
    if (!deck.isEditable) {
      return null;
    }

    final now = DateTime.now();
    final listing =
        deck.listing ??
        DeckListing(deckId: deck.id, createdAt: now, updatedAt: now);
    final featuredCards = listing.featuredCards.toList();
    final hasTemplate = featuredCards.any((card) => card['id'] == template.id);
    if (hasTemplate) {
      return null;
    }

    final updatedListing = listing.copyWith(
      featuredCards: [...featuredCards, template.toMap()],
      updatedAt: now,
    );
    final updatedDeck = deck.copyWith(listing: updatedListing, updatedAt: now);

    await LocalDB.deck.upsert(updatedDeck);
    await LocalDB.deckListing.upsert(updatedListing);
    return updatedDeck;
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
