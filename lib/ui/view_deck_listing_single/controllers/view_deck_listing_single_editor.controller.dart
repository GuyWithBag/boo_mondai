import 'package:boo_mondai/features/profile/models/profile.dto.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        CardTemplate,
        Content,
        Deck,
        DeckListing,
        DeckListingsService,
        DecksService,
        LocalDB,
        ButtonColor,
        ModalAction,
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
  });

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

  final featuredImages = listSignal<ImageProvider?>(List.filled(3, null));
  final featuredCards = listSignal<CardTemplate>([]);

  final formKey = GlobalKey<FormState>();

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
    // await DeckListingsService.setFeaturedImageByFile(
    //   deck: deck.value,
    //   listing: listing.value,
    //   content: content.value,
    //   index: index,
    //   file: file,
    // );

    // ToDo: Add error handling
    if (file == null || file.bytes == null) return;

    featuredImages.value[index] = MemoryImage(file.bytes!);
  }

  List<CardTemplate> getFeaturedCardTemplates() {
    final featuredCardIds = {
      for (final card in listing.value.featuredCards)
        if (card['id'] case final String id) id,
    };

    return LocalDB.cardTemplate
        .getByDeckId(deck.value.id)
        .where((template) => !featuredCardIds.contains(template.id))
        .toList(growable: false);
  }

  Future<void> addFeaturedCard({
    required BuildContext context,
    required Widget modalChild,
  }) async {
    final templates = getFeaturedCardTemplates();

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

    // final updatedDeck = await DeckListingsService.addListingFeaturedCard(
    //   deck: deck.value,
    //   listing: listing.value,
    //   content: content.value,
    //   template: template,
    // );

    // if (updatedDeck != null) deck.value = updatedDeck;

    featuredCards.value = [...featuredCards.value, selected];
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
      Navigator.of(context).pop();
    }
  }
}
