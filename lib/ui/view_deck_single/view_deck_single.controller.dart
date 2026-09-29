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
        ProfileService,
        ViewDeckListingSingleEditorController,
        showViewDeckListingSingleSheet,
        showModal,
        ViewDeckSingleHelper,
        FileSystemHandler,
        ImageHelper;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';

class ViewDeckSingleSheetController {
  ViewDeckSingleSheetController({
    required this.coverImage,
    required this.initialDeck,
  }) : deck = signal(initialDeck);

  final Deck initialDeck;
  final Signal<Deck> deck;
  final Signal<ImageProvider?> coverImage;

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

  Future<void> onCreateListingPressed(BuildContext context) async {
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

    deck.value = deck.value.copyWith(
      title: value.trim(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> setShortDescription(String value) async {
    // final updatedDeck = await DecksService.update(
    //   deck: deck.value,
    //   content: content.value,
    //   shortDescription: value,
    // );

    deck.value = deck.value.copyWith(
      shortDescription: value.trim(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> setLongDescription(String value) async {
    // final updatedDeck = await DecksService.update(
    //   deck: deck.value,
    //   content: content.value,
    //   longDescription: value,
    // );

    deck.value = deck.value.copyWith(
      longDescription: value.trim(),
      updatedAt: DateTime.now(),
    );
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
    coverImage.value = MemoryImage(file.bytes!);
  }

  void onExit() {
    save();
  }

  void save() {
    if (initialDeck.title != deck.value.title) {
      DecksService.setTitle(deck: deck.value, title: deck.value.title);
    }

    if (initialDeck != deck.value) {
      DecksService.upsert(deck: deck.value);
    }
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
    onExit();

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
