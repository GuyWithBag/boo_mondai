import 'package:boo_mondai/features/profile/models/profile.dto.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        ButtonColor,
        CardTemplate,
        Content,
        Deck,
        DeckListing,
        DeckListingsService,
        DecksService,
        ModalAction,
        ModalDraftActionType,
        showModal,
        showSnackbar;
import 'package:boo_mondai/ui/view_deck_listing_single/controllers/view_deck_listing_single.controller.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/material.dart';

import 'package:signals/signals_flutter.dart';

// ToDo: I need to change this so that it edits the current deck signal then when exited or pressed save, it applies the changes.

class ViewDeckListingSingleEditorController
    implements ViewDeckListingSingleController {
  ViewDeckListingSingleEditorController({
    required this.deck,
    required this.content,
    required this.listing,
    required this.profile,
    required this.sourceProfile,
  }) : initialDeck = deck.value,
       initialContent = content.value,
       initialListing = listing.value {
    initializeDraft();
  }

  final Deck initialDeck;
  final Content initialContent;
  final DeckListing initialListing;

  @override
  final error = signal<Exception?>(null);

  @override
  final Signal<Deck> deck;
  @override
  final Signal<Content> content;
  @override
  final Signal<DeckListing> listing;
  @override
  final Signal<Profile> profile;
  @override
  final Signal<Profile> sourceProfile;

  late final List<MemoryImage> initialFeaturedImages;
  final featuredImages = listSignal<MemoryImage>([]);
  final canClose = signal(false);

  final formKey = GlobalKey<FormState>();

  Future<void> initializeDraft() async {
    initialFeaturedImages = await DeckListingsService.getFeaturedMemoryImages(
      deck: initialDeck,
      listing: initialListing,
    );
    featuredImages.value = initialFeaturedImages;
  }

  Future<void> setTitle(String value) async {
    // deck.value = await DecksService.setTitle(
    //   deck: deck.value,
    //   content: content.value,
    //   title: value,
    // );
    deck.value = deck.value.copyWith(title: value.trim());
  }

  Future<void> setShortDescription(String value) async {
    // deck.value = await DecksService.setShortDescription(
    //   deck: deck.value,
    //   content: content.value,
    //   shortDescription: value,
    // );
    //
    deck.value = deck.value.copyWith(shortDescription: value.trim());
  }

  Future<void> setLongDescription(String value) async {
    // final updatedDeck = await DecksService.setLongDescription(
    //   deck: deck,
    //   content: content.value,
    //   longDescription: value,
    // );
    deck.value = deck.value.copyWith(longDescription: value.trim());
  }

  // ToDo: Work on this in the future because right now tags are confusing as heck!
  Future<void> setTags(List<String> tagNames) async {
    final updatedDeck = await DecksService.setTags(
      deck: deck.value,
      content: content.value,
      tagNames: tagNames,
    );
    // applyUpdatedDeck(updatedDeck);

    if (updatedDeck != null) deck.value = updatedDeck;
  }

  Future<void> upsertFeaturedImage(int index, PlatformFile? file) async {
    if (file == null) return;

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return;

    final image = MemoryImage(bytes);
    final newImages = featuredImages.value.toList();

    if (index < newImages.length) {
      newImages[index] = image;
    } else {
      newImages.add(image);
    }

    featuredImages.value = newImages;
  }

  Future<void> addFeaturedCard({
    required BuildContext context,
    required Widget modalChild,
  }) async {
    final templates = listing.value.featuredCards;

    if (templates.isEmpty) {
      showSnackbar(
        context,
        message: 'You do not have any templates available for selection.',
      );
      return;
    }

    final selected = await showModal<CardTemplate>(
      context: context,
      title: 'Add featured card',
      child: modalChild,
    );
    if (selected == null) return;

    listing.value = listing.value.copyWith(
      featuredCards: [...listing.value.featuredCards, selected],
    );
  }

  Future<void> save() async {
    final now = DateTime.now();
    final updatedDeck = deck.value.copyWith(updatedAt: now);
    final result = await DeckListingsService.upsertFeaturedImagesFromImages(
      deck: deck.value,
      listing: listing.value,
      content: content.value,
      images: featuredImages.value,
    );

    await DeckListingsService.upsertListing(
      deck: updatedDeck,
      listing: result.listing,
      content: result.content,
    );

    deck.value = updatedDeck;
    content.value = result.content;
    listing.value = result.listing;
  }

  Future<bool> onClose(BuildContext context) async {
    if ((initialDeck == deck.value) &&
        (initialFeaturedImages == featuredImages.value)) {
      return true;
    }

    final action = await showModal<ModalDraftActionType>(
      context: context,
      title: 'Save listing changes?',
      subtitle: 'You have unsaved changes in this listing.',
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
    listing.value = initialListing;
    content.value = initialContent;
  }

  ButtonColor getPublishedButtonColor() {
    if (deck.value.isPublished) {
      return ButtonColor.hard;
    }
    return ButtonColor.error;
  }

  IconData getPublishedButtonIcon() {
    if (deck.value.isPublished) {
      return Icons.public_outlined;
    }
    return Icons.public_off_outlined;
  }

  Future<void> togglePublished({required BuildContext context}) async {
    await setPublished(context: context, isPublished: !deck.value.isPublished);
  }

  Future<void> setPublished({
    required BuildContext context,
    required bool isPublished,
  }) async {
    if (!deck.value.isEditable) return;
    if (!AuthService.isAuthenticatedRemote) {
      error.value = Exception('Sign in to update deck listing publishing.');
      return;
    }

    final confirmed = await showModal<bool>(
      context: context,
      title: 'Publish this listing?',
      subtitle:
          'This will make it available for others to download. Sync your changes in order to make this available online.',
      leading: const Icon(Icons.public_outlined),
      actions: [
        ModalAction(label: 'Cancel', value: false),
        ModalAction(label: 'Publish', value: true, color: ButtonColor.success),
      ],
    );

    if (confirmed != true) return;

    final updatedDeck = await DecksService.setPublished(
      deck: deck.value,
      isPublished: isPublished,
    );

    if (updatedDeck != null) deck.value = updatedDeck;
  }

  Future<void> deleteListing({required BuildContext context}) async {
    if (!deck.value.isEditable) return;

    final confirmed = await showModal<bool>(
      context: context,
      title: 'Delete deck listing?',
      subtitle:
          '"${deck.value.title}" will be removed from published listings. The deck and its cards will stay in your library.',
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

    final updatedDeck = await DeckListingsService.deleteListing(
      deck: deck.value,
      listing: listing.value,
      content: content.value,
    );

    if (updatedDeck != null) deck.value = updatedDeck;

    if (context.mounted) {
      canClose.value = true;
      Navigator.of(context).pop();
    }
  }
}
