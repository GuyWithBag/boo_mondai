import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonColor,
        Content,
        ContentType,
        Deck,
        DeckListing,
        DeckListingsService,
        DecksDirectoryPaths,
        DecksService,
        LocalDB,
        ModalAction,
        ModalDraftActionType,
        ProfileService,
        SettingPath,
        SettingsStore,
        ViewDeckListingSingleEditorController,
        showFeatureDisabledModal,
        showViewDeckListingSingleSheet,
        showModal,
        ViewDeckSingleHelper,
        FileSystemHandler,
        ImageHelper;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:signals_hooks/signals_hooks.dart';

class ViewDeckSingleSheetController {
  ViewDeckSingleSheetController({
    required this.coverImage,
    required this.initialDeck,
  }) : deck = signal(initialDeck);

  Deck initialDeck;
  final Signal<Deck> deck;
  final Signal<ImageProvider?> coverImage;
  final pickedCoverImageFile = signal<PlatformFile?>(null);
  final isLoading = signal(false);
  final canClose = signal(false);
  bool _isRequestingClose = false;

  late final FutureSignal<ImageProvider?> coverImageFuture = futureSignal(
    () async {
      return await ImageHelper.getImageProviderFromSource(
        DecksDirectoryPaths.coverImage(deckTitle: deck.value.title),
      );
    },
  );

  late final controllerEffect = effect(() {
    coverImageFuture.value.map(
      error: () {},
      loading: () {},
      data: (value) {
        coverImage.value = value;
      },
    );
  });

  late final title = computed(
    () => ViewDeckSingleHelper.getTitle(deck.value.title),
  );
  late final isDirty = computed(
    () => initialDeck != deck.value || pickedCoverImageFile.value != null,
  );
  late final canEdit = computed(() => deck.value.isEditable);
  late final shouldShowSaveButton = computed(
    () => isDirty.value || isLoading.value,
  );
  late final canSave = computed(() => isDirty.value && !isLoading.value);
  late final shortDescription = computed(
    () => ViewDeckSingleHelper.getShortDescription(deck.value.shortDescription),
  );
  late final longDescription = computed(
    () => ViewDeckSingleHelper.getLongDescription(deck.value.longDescription),
  );
  late final profile = computed(
    () => LocalDB.profiles.selectByPk({'id': deck.value.profileId}),
  );
  late final profileName = computed(
    () => ViewDeckSingleHelper.getProfileName(profile.value?.displayName),
  );
  late final visibilityLabel = computed(
    () => ViewDeckSingleHelper.getVisibilityLabel(deck.value.visibilityState),
  );
  late final tagNames = computed(
    () => deck.value.tags.map((tag) => tag.name).toList(growable: false),
  );
  late final coverImagePath = computed(
    () => DecksDirectoryPaths.coverImage(deckTitle: deck.value.title),
  );

  static Content resolveDeckContent(Deck deck) {
    final existing = LocalDB.contents.selectByPk({'id': deck.id});
    if (existing != null) return existing;

    return Content(
      id: deck.id,
      profileId: deck.profileId,
      createdAt: deck.createdAt,
      updatedAt: deck.updatedAt,
      type: ContentType.deck,
    );
  }

  Future<void> requestClose(BuildContext context) async {
    if (_isRequestingClose) return;
    _isRequestingClose = true;

    final shouldClose = await onClose(context);
    if (!context.mounted) return;
    if (!shouldClose) {
      _isRequestingClose = false;
      return;
    }

    canClose.value = true;
    Navigator.of(context).pop();
  }

  void onEditPressed(BuildContext context) {
    if (!deck.value.isEditable) return;
    context.push('/decks-local/${deck.value.id}/edit');
  }

  Future<void> onCreateListingPressed(BuildContext context) async {
    final areOnlineFeaturesDisabled = SettingsStore.instance.get<bool>(
      SettingPath.disableOnlineFeatures,
    );
    if (areOnlineFeaturesDisabled) {
      showFeatureDisabledModal(context);
      return;
    }

    if (deck.value.isPublished) return;

    final shouldCreateListing = await showModal<bool>(
      context: context,
      title: 'Create deck listing?',
      subtitle:
          'This will create a listing of this deck to publish online. You will have to publish it in the listing.',
      leading: const Icon(Icons.public_outlined),
      actions: [
        const ModalAction<bool>(value: false, label: 'Cancel'),
        const ModalAction<bool>(
          value: true,
          label: 'Create',
          color: ButtonColor.primary,
        ),
      ],
    );
    if (shouldCreateListing != true) return;

    final result = await DeckListingsService.createListing(deck.value);

    if (context.mounted) {
      await showViewDeckListingSingleSheet(
        context: context,
        controller: ViewDeckListingSingleEditorController(
          deck: deck,
          content: signal(result.deckListingContent),
          listing: signal<DeckListing>(result.deckListing),
          profile: ProfileService.currentProfile,
          // ToDo: isnt this supposed to be nullable?
          sourceProfile: ProfileService.currentProfile,
        ),
      );
    }
  }

  Future<void> showDeckPath(BuildContext context) async {
    final mediaDirectoryPath =
        await FileSystemHandler.getAbsolutePathOfRelativePath(deck.value.title);
    if (!context.mounted) return;

    await showModal<void>(
      context: context,
      leading: const Icon(Icons.folder_outlined),
      title: 'Deck path',
      child: SelectableText(
        ['Media directory:', mediaDirectoryPath, ''].join('\n'),
      ),
      showCancelButton: true,
    );
  }

  Future<void> setTitle(String value) async {
    // await DecksService.setTitle(
    //   deck: deck.value,
    //   content: content.value,
    //   title: value,
    // );

    deck.value = deck.value.copyWith(title: value.trim());
  }

  Future<void> setShortDescription(String value) async {
    // final updatedDeck = await DecksService.update(
    //   deck: deck.value,
    //   content: content.value,
    //   shortDescription: value,
    // );

    deck.value = deck.value.copyWith(shortDescription: value.trim());
  }

  Future<void> setLongDescription(String value) async {
    // final updatedDeck = await DecksService.update(
    //   deck: deck.value,
    //   content: content.value,
    //   longDescription: value,
    // );

    deck.value = deck.value.copyWith(longDescription: value.trim());
  }

  Future<void> setTags(List<String> tagNames) async {
    // final updatedDeck = await DecksService.setTags(
    //   deck: deck.value,
    //   content: content.value,
    //   tagNames: tagNames,
    // );

    // deck.value = deck.value.copyWith();
  }

  Future<void> onCoverImagePicked(PlatformFile file) async {
    // await DecksService.setCoverImageUrlByFile(
    //   deck: deck.value,
    //   content: content.value,
    //   file: file,
    // );

    // ToDo: Add error handling
    if (file.bytes == null) return;
    pickedCoverImageFile.value = file;
    coverImage.value = MemoryImage(file.bytes!);
  }

  Future<void> save() async {
    if (!isDirty.value || isLoading.value) return;

    isLoading.value = true;
    try {
      final draft = deck.value.copyWith(updatedAt: DateTime.now());
      if (initialDeck.title != draft.title) {
        await DecksService.setTitle(deck: initialDeck, title: draft.title);
      }

      final pickedCover = pickedCoverImageFile.value;
      if (pickedCover != null) {
        final coverImagePath = DecksDirectoryPaths.coverImage(
          deckTitle: draft.title,
        );
        final absolutePath =
            await FileSystemHandler.getAbsolutePathOfRelativePath(
              coverImagePath,
            );
        await FileSystemHandler.storeFile(
          path: absolutePath,
          file: pickedCover,
        );
      }

      await DecksService.upsert(deck: draft);
      deck.value = draft;
      initialDeck = draft;
      pickedCoverImageFile.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onSavePressed() => save();

  Future<bool> onClose(BuildContext context) async {
    if (!isDirty.value) return true;

    final action = await showModal<ModalDraftActionType>(
      context: context,
      title: 'Save deck changes?',
      subtitle: 'You have unsaved changes in this deck.',
      leading: const Icon(Icons.save_outlined),
      showCancelButton: true,
      actions: [
        const ModalAction<ModalDraftActionType>(
          value: ModalDraftActionType.discard,
          label: 'Discard',
        ),
        const ModalAction<ModalDraftActionType>(
          value: ModalDraftActionType.action,
          label: 'Save',
          color: ButtonColor.primary,
        ),
      ],
    );

    switch (action ?? ModalDraftActionType.cancel) {
      case ModalDraftActionType.action:
        await save();
        return true;
      case ModalDraftActionType.discard:
        discard();
        return true;
      case ModalDraftActionType.cancel:
        return false;
    }
  }

  void discard() {
    deck.value = initialDeck;
    pickedCoverImageFile.value = null;
    coverImageFuture.refresh();
  }

  Future<void> deleteDeck(BuildContext context) async {
    final confirmed = await showModal<bool>(
      context: context,
      title: 'Delete deck?',
      // ToDo: fix this
      subtitle:
          '"${ViewDeckSingleHelper.getTitle(deck.value.title)}" and all its cards will be removed.',
      leading: const Icon(Icons.delete_outline),
      actions: [
        const ModalAction<bool>(value: false, label: 'Cancel'),
        const ModalAction<bool>(
          value: true,
          label: 'Delete',
          color: ButtonColor.error,
        ),
      ],
    );
    if (confirmed != true) return;

    await DecksService.deleteDeckCascades(deck: deck.value);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void dispose() {
    canClose.dispose();
    isLoading.dispose();
    pickedCoverImageFile.dispose();
    canEdit.dispose();
    canSave.dispose();
    shouldShowSaveButton.dispose();
    isDirty.dispose();
    coverImagePath.dispose();
    tagNames.dispose();
    visibilityLabel.dispose();
    profileName.dispose();
    profile.dispose();
    longDescription.dispose();
    shortDescription.dispose();
    title.dispose();
    deck.dispose();
  }
}
