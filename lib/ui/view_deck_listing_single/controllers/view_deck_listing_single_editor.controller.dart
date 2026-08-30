import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        CardTemplate,
        Controller,
        Deck,
        DeckListingsService,
        DecksService,
        LocalDB,
        ButtonColor,
        ModalAction,
        showModal,
        ViewDeckSingleHelper;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/foundation.dart' show ValueChanged;
import 'package:flutter/material.dart'
    show BuildContext, Icon, Icons, Navigator;
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

ViewDeckListingSingleEditorController useViewDeckListingSingleEditorController({
  required BuildContext context,
  required Deck Function() deckReader,
  required ValueChanged<Deck?> onDeckUpdated,
}) {
  final controller = useMemoized(
    () => ViewDeckListingSingleEditorController(
      context: context,
      deckReader: deckReader,
      onDeckUpdated: onDeckUpdated,
    ),
    const [],
  );

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}

class ViewDeckListingSingleEditorController extends Controller {
  ViewDeckListingSingleEditorController({
    required BuildContext context,
    required Deck Function() deckReader,
    required ValueChanged<Deck?> onDeckUpdated,
  }) : _context = context,
       _deckReader = deckReader,
       _onDeckUpdated = onDeckUpdated;

  final BuildContext _context;
  final Deck Function() _deckReader;
  final ValueChanged<Deck?> _onDeckUpdated;

  Deck get _deck => _deckReader();

  bool get canEdit {
    final localDeck = LocalDB.deck.selectByPk({'id': _deck.id});
    return localDeck != null && localDeck.isEditable;
  }

  Future<void> setTitle(String value) async {
    final updatedDeck = await DecksService.setTitle(deck: _deck, title: value);
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> setShortDescription(String value) async {
    final updatedDeck = await DecksService.update(
      deck: _deck,
      shortDescription: value,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> setLongDescription(String value) async {
    final updatedDeck = await DecksService.update(
      deck: _deck,
      longDescription: value,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> setTags(List<String> tagNames) async {
    final updatedDeck = await DecksService.setTags(
      deck: _deck,
      tagNames: tagNames,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> updateListingFeaturedImage(int index, PlatformFile file) async {
    await DeckListingsService.setFeaturedImageByFile(
      deck: _deck,
      index: index,
      file: file,
    );
  }

  List<CardTemplate> availableFeaturedCardTemplates() {
    final featuredCardIds = {
      for (final card in _deck.listing?.featuredCards ?? const [])
        if (card['id'] case final String id) id,
    };

    return LocalDB.cardTemplate
        .getByDeckId(_deck.id)
        .where((template) => !featuredCardIds.contains(template.id))
        .toList(growable: false);
  }

  Future<void> addListingFeaturedCard(CardTemplate template) async {
    final updatedDeck = await DeckListingsService.addListingFeaturedCard(
      deck: _deck,
      template: template,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  ButtonColor getPublishedButtonColor() {
    if (_deck.isPublished) {
      return ButtonColor.hard;
    }
    return ButtonColor.error;
  }

  IconData getPublishedButtonIcon() {
    if (_deck.isPublished) {
      return Icons.public_outlined;
    }
    return Icons.public_off_outlined;
  }

  Future<void> togglePublished() async {
    await setPublished(!_deck.isPublished);
  }

  Future<void> setPublished(bool isPublished) async {
    if (!canEdit) return;
    if (!AuthService.isAuthenticatedRemote) {
      setError(Exception('Sign in to update deck listing publishing.'));
      return;
    }

    final confirmed = await showModal<bool>(
      context: _context,
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

    final updatedDeck = await DeckListingsService.setPublished(
      deck: _deck,
      isPublished: isPublished,
    );
    _applyUpdatedDeck(updatedDeck);
  }

  Future<void> deleteListing() async {
    if (!canEdit || _deck.listing == null) return;

    final confirmed = await showModal<bool>(
      context: _context,
      title: 'Delete deck listing?',
      subtitle:
          '"${ViewDeckSingleHelper.title(_deck)}" will be removed from published listings. The deck and its cards will stay in your library.',
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

    final updatedDeck = await DeckListingsService.deleteListing(_deck);
    _applyUpdatedDeck(updatedDeck);
    if (_context.mounted) {
      Navigator.of(_context).pop();
    }
  }

  void _applyUpdatedDeck(Deck? updatedDeck) {
    if (updatedDeck == null) return;

    _onDeckUpdated(updatedDeck);
    notifyListeners();
  }
}
